# Zero Trust End-to-End Validation Runbook

This runbook proves the full control path in a disposable Azure lab:

**Architecture → Terraform → Sentinel detection → automation → analyst approval → remediation → post-remediation validation**

Use a dedicated resource group. Do not run the destructive steps against production resources.

---

## 1. Lab scope

Recommended resource group:

`rg-zt-validation-lab`

Set variables:

~~~bash
export SUBSCRIPTION_ID="$(az account show --query id -o tsv)"
export LOCATION="westus2"
export LAB_RG="rg-zt-validation-lab"
export TF_DIR="terraform/enterprise-application"
~~~

Create the lab resource group:

~~~bash
az group create   --name "$LAB_RG"   --location "$LOCATION"
~~~

Expected result:

- resource group exists;
- all test resources stay inside this scope where practical.

---

## 2. Deploy the Zero Trust Enterprise Application stack

From the repo root:

~~~bash
cd "$TF_DIR"

cp terraform.tfvars.example terraform.tfvars

terraform init
terraform fmt -check
terraform validate

terraform plan   -var="resource_group_name=$LAB_RG"   -var="location=$LOCATION"

terraform apply   -var="resource_group_name=$LAB_RG"   -var="location=$LOCATION"
~~~

Capture outputs:

~~~bash
export WEB_APP_NAME="$(terraform output -raw web_app_name)"
export KEY_VAULT_NAME="$(terraform output -raw key_vault_name)"
export STORAGE_ACCOUNT_NAME="$(terraform output -raw storage_account_name)"
export APP_IDENTITY_CLIENT_ID="$(terraform output -raw app_identity_client_id)"
export APP_IDENTITY_PRINCIPAL_ID="$(terraform output -raw app_identity_principal_id)"
export LOG_ANALYTICS_WORKSPACE_ID="$(terraform output -raw log_analytics_workspace_id)"
export RESOURCE_GROUP="$LAB_RG"
~~~

Return to repo root:

~~~bash
cd ../..
~~~

Expected result:

- App Service public access disabled;
- Key Vault public access disabled;
- Storage public access disabled;
- private endpoints exist;
- managed identity exists;
- diagnostics target Log Analytics.

---

## 3. Run baseline negative-security tests

Make the test scripts executable:

~~~bash
chmod +x tests/enterprise-application/*.sh
~~~

Run the control-plane suite:

~~~bash
tests/enterprise-application/run-control-plane-tests.sh
~~~

Expected:

~~~text
PASS  App Service public access disabled
PASS  Key Vault public access disabled
PASS  Storage public access disabled
PASS  Storage shared-key access disabled
PASS  App Service has an approved private endpoint
PASS  Key Vault has an approved private endpoint
PASS  Storage has an approved private endpoint
PASS  Workload identity has Storage Blob Data Reader
PASS  Workload identity has Key Vault Secrets User
PASS  No broad admin/write role detected
PASS  Key Vault diagnostics target the expected workspace
PASS  Storage diagnostics target the expected workspace
PASS  All control-plane negative-security tests passed.
~~~

Do not continue until the baseline is clean.

---

## 4. Deploy Sentinel analytics rules

Deploy the three rules from the Sentinel KQL Library:

~~~bash
az deployment group create   --resource-group <sentinel-workspace-resource-group>   --template-file deploy/bicep/zero-trust-analytics/main.bicep   --parameters       workspaceName=<sentinel-workspace-name>       enableRules=false
~~~

Run the KQL manually in Sentinel first and confirm `AzureActivity` is populated.

Then enable:

~~~bash
az deployment group create   --resource-group <sentinel-workspace-resource-group>   --template-file deploy/bicep/zero-trust-analytics/main.bicep   --parameters       workspaceName=<sentinel-workspace-name>       enableRules=true
~~~

Wait at least one rule interval before testing.

---

## 5. Deploy first-stage SOAR playbooks and automation rules

Deploy:

- PB-ZT-001 Exposure Change Response
- PB-ZT-002 RBAC Assignment Response
- PB-ZT-003 Diagnostics Changed Response

Then deploy the automation-rule package with:

~~~text
enableAutomationRules=false
~~~

Validate:

- Sentinel connector is healthy;
- each Logic App managed identity can update incidents;
- Sentinel Automation Contributor is assigned on the playbook resource group.

Then redeploy with:

~~~text
enableAutomationRules=true
~~~

---

# TEST A — HA-ZT-002 Privileged RBAC Assignment

## 6. Create a sacrificial identity

Create a test service principal:

~~~bash
export TEST_SP_NAME="sp-zt-rbac-validation"

az ad sp create-for-rbac   --name "$TEST_SP_NAME"   --skip-assignment
~~~

Capture its object ID:

~~~bash
export TEST_SP_OBJECT_ID="$(az ad sp list   --display-name "$TEST_SP_NAME"   --query '[0].id'   -o tsv)"
~~~

Confirm:

~~~bash
echo "$TEST_SP_OBJECT_ID"
~~~

---

## 7. Create the sacrificial role assignment

Use only the lab resource group scope.

~~~bash
export LAB_SCOPE="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$LAB_RG"
export TEST_ROLE_ASSIGNMENT_ID="$(python3 - <<'PY'
import uuid
print(uuid.uuid4())
PY
)"

az role assignment create   --assignee-object-id "$TEST_SP_OBJECT_ID"   --assignee-principal-type ServicePrincipal   --role "Contributor"   --scope "$LAB_SCOPE"   --name "$TEST_ROLE_ASSIGNMENT_ID"
~~~

Azure CLI supports explicit role-assignment names, which gives this test a deterministic target.

Verify:

~~~bash
az role assignment list   --assignee-object-id "$TEST_SP_OBJECT_ID"   --scope "$LAB_SCOPE"   -o table
~~~

Expected:

- one Contributor role assignment exists at the lab RG scope.

---

## 8. Confirm HA-ZT-002 detection and first-stage automation

Allow the analytics rule to run.

Expected Sentinel outcome:

- HA-ZT-002 incident is created;
- severity = High;
- labels include:
  - `ZeroTrust`
  - `PrivilegedAccess`
- incident task asks you to resolve and validate the assignment;
- first-stage playbook adds investigation guidance.

Before approving remediation, confirm the role assignment ID in the incident matches the sacrificial assignment.

---

## 9. Prove the remediation safety gate

Run `PB-ZT-002-Remediate-RBAC` manually **without** adding `RemediationApproved`.

Expected:

- no RBAC deletion;
- incident receives a comment stating remediation was blocked by the safety gate.

Confirm the assignment still exists:

~~~bash
az role assignment show   --name "$TEST_ROLE_ASSIGNMENT_ID"   --scope "$LAB_SCOPE"
~~~

---

## 10. Approve and run RBAC remediation

After confirming this is the sacrificial assignment:

1. add the incident label `RemediationApproved`;
2. run `PB-ZT-002-Remediate-RBAC` manually.

Expected:

- playbook validates the exact role-assignment resource;
- only that assignment is deleted;
- post-remediation GET returns not found;
- incident receives the remediation success comment.

Verify independently:

~~~bash
az role assignment show   --name "$TEST_ROLE_ASSIGNMENT_ID"   --scope "$LAB_SCOPE"
~~~

Expected:

~~~text
RoleAssignmentNotFound
~~~

Run the least-privilege validation again:

~~~bash
tests/enterprise-application/test-least-privilege-rbac.sh
~~~

Expected:

~~~text
PASS
~~~

---

# TEST B — HA-ZT-003 Diagnostic Settings Changed

## 11. Capture the current Key Vault diagnostic setting

Get the Key Vault resource ID:

~~~bash
export KV_ID="$(az keyvault show   --resource-group "$LAB_RG"   --name "$KEY_VAULT_NAME"   --query id   -o tsv)"
~~~

List diagnostic settings:

~~~bash
az monitor diagnostic-settings list   --resource "$KV_ID"   -o table
~~~

The Terraform reference implementation uses:

~~~text
send-to-log-analytics
~~~

Capture the setting before modifying anything:

~~~bash
az monitor diagnostic-settings show   --resource "$KV_ID"   --name "send-to-log-analytics"   -o json > /tmp/zt-kv-diagnostics-before.json
~~~

---

## 12. Trigger HA-ZT-003

Delete only the lab Key Vault diagnostic setting:

~~~bash
az monitor diagnostic-settings delete   --resource "$KV_ID"   --name "send-to-log-analytics"
~~~

Azure CLI supports diagnostic-settings create, delete, list, and show against a resource ID.

Confirm deletion:

~~~bash
az monitor diagnostic-settings list   --resource "$KV_ID"   -o table
~~~

Expected:

- `send-to-log-analytics` is absent.

---

## 13. Confirm HA-ZT-003 incident and first-stage automation

Allow the analytics rule to run.

Expected Sentinel outcome:

- HA-ZT-003 incident created;
- severity = High;
- labels:
  - `ZeroTrust`
  - `TelemetryIntegrity`
- task: restore and validate diagnostic telemetry;
- first-stage playbook adds response guidance.

---

## 14. Prove the diagnostics remediation safety gate

Run `PB-ZT-003-Restore-Diagnostics` manually **without** `RemediationApproved`.

Expected:

- no diagnostic setting created;
- playbook writes a safety-gate-blocked comment.

Confirm:

~~~bash
az monitor diagnostic-settings list   --resource "$KV_ID"   -o table
~~~

The setting should still be absent.

---

## 15. Approve and restore diagnostics

After validating the incident:

1. add `RemediationApproved`;
2. run `PB-ZT-003-Restore-Diagnostics`.

Expected:

- diagnostic setting recreated;
- destination is the approved Log Analytics workspace;
- audit category group enabled;
- AllMetrics enabled;
- post-remediation verification succeeds;
- incident receives validation comment.

Verify:

~~~bash
az monitor diagnostic-settings show   --resource "$KV_ID"   --name "send-to-log-analytics"   --query 'workspaceId'   -o tsv
~~~

Expected:

~~~text
$LOG_ANALYTICS_WORKSPACE_ID
~~~

Run the test:

~~~bash
tests/enterprise-application/test-diagnostic-settings.sh
~~~

Expected:

~~~text
PASS
~~~

---

# TEST C — HA-ZT-001 Exposure Change

## 16. Use a disposable resource only

Do not expose a production resource.

Capture Key Vault public-access state:

~~~bash
az keyvault show   --resource-group "$LAB_RG"   --name "$KEY_VAULT_NAME"   --query properties.publicNetworkAccess   -o tsv
~~~

Expected:

~~~text
Disabled
~~~

Temporarily enable it on this disposable lab vault:

~~~bash
az keyvault update   --resource-group "$LAB_RG"   --name "$KEY_VAULT_NAME"   --public-network-access Enabled
~~~

Allow HA-ZT-001 to trigger.

Expected:

- exposure-change incident;
- `ZeroTrust` and `ExposureChange` labels;
- validation task;
- playbook response guidance.

Immediately restore:

~~~bash
az keyvault update   --resource-group "$LAB_RG"   --name "$KEY_VAULT_NAME"   --public-network-access Disabled
~~~

Run:

~~~bash
tests/enterprise-application/test-public-endpoints-disabled.sh
~~~

Expected:

~~~text
PASS
~~~

---

# 17. Private DNS and workload identity runtime validation

Run these from a host with VNet/private DNS reachability.

Private DNS:

~~~bash
tests/enterprise-application/test-private-dns.sh
~~~

Expected:

- App Service hostname resolves to private IP;
- Key Vault hostname resolves to private IP;
- Storage Blob hostname resolves to private IP.

For managed-identity read/write tests, seed a harmless blob with an administrative identity first.

Then run:

~~~bash
export AZURE_CLIENT_ID="$APP_IDENTITY_CLIENT_ID"
export STORAGE_ACCOUNT_NAME="$STORAGE_ACCOUNT_NAME"
export TEST_CONTAINER="zero-trust-validation"
export TEST_BLOB="read-test.txt"

pip install -r tests/enterprise-application/requirements.txt

python tests/enterprise-application/runtime_storage_tests.py
~~~

Expected:

~~~text
PASS  ZT-NEG-006 Managed identity read succeeded
PASS  ZT-NEG-007 Unauthorized write was denied
~~~

---

# 18. Evidence to capture

For each scenario, save:

| Evidence | Capture |
|---|---|
| Baseline control state | CLI output |
| Trigger action | Azure Activity Log / command |
| Sentinel alert | Alert screenshot or incident ID |
| Incident | Incident ID + title |
| Entity mapping | Account, IP, Azure Resource |
| Automation result | labels + task |
| Playbook result | Logic App run history |
| Safety gate | blocked-remediation incident comment |
| Approval | `RemediationApproved` label |
| Remediation | ARM/CLI resource state |
| Verification | post-action command output |
| Negative test | PASS output |

This gives you defensible proof that the system works end to end.

---

# 19. Cleanup

Remove the sacrificial service principal:

~~~bash
az ad sp delete   --id "$TEST_SP_OBJECT_ID"
~~~

Destroy the disposable Terraform stack when finished:

~~~bash
cd "$TF_DIR"

terraform destroy   -var="resource_group_name=$LAB_RG"   -var="location=$LOCATION"

cd ../..
~~~

If anything remains:

~~~bash
az group delete   --name "$LAB_RG"   --yes
~~~

---

# 20. Release gate

Call the implementation **end-to-end validated** only when all of the following are true:

- Terraform validation passes;
- baseline negative tests pass;
- HA-ZT-001, HA-ZT-002, and HA-ZT-003 generate incidents;
- entity mapping contains the expected target;
- first-stage automation executes;
- remediation without approval is blocked;
- remediation with approval targets only the intended resource;
- post-remediation verification succeeds;
- negative-security tests pass after remediation;
- the entire lab can be cleaned up without touching unrelated resources.

If one of those conditions is not proven, record the gap rather than marking the control validated.
