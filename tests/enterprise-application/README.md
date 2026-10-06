# Negative-Security Validation — Enterprise Application

These tests validate the **failure paths** in the Zero Trust Enterprise Application reference architecture.

The goal is not to prove that resources exist. The goal is to prove that controls fail safely when someone tries to bypass them.

## Test matrix

| ID | Test | Expected result | Run from |
|---|---|---|---|
| ZT-NEG-001 | Public endpoints remain disabled | PASS only when App Service, Key Vault, and Storage public access are disabled | Any host with Azure CLI control-plane access |
| ZT-NEG-002 | Private endpoints exist and are approved | PASS only when required private endpoint connections are present and approved | Any host with Azure CLI control-plane access |
| ZT-NEG-003 | Workload identity has least privilege | PASS only when expected narrow roles exist and broad write/admin roles do not | Any host with Azure CLI control-plane access |
| ZT-NEG-004 | Diagnostic settings exist | PASS only when Key Vault and Storage diagnostics point to the expected Log Analytics workspace | Any host with Azure CLI control-plane access |
| ZT-NEG-005 | Private DNS resolves to private addresses | PASS only when protected service names resolve to private IPs | Host with VNet/private DNS reachability |
| ZT-NEG-006 | Managed identity can read approved test data | PASS only when workload identity can read the seeded test blob | Workload/VNet host using the managed identity |
| ZT-NEG-007 | Managed identity cannot write to Blob Storage | PASS only when an attempted test upload is denied | Workload/VNet host using the managed identity |

## Safety

The write-denial test attempts to create a uniquely named object under a dedicated test prefix. If the write unexpectedly succeeds, the test reports a security failure and attempts to delete only the object it created.

## Control-plane tests

Export:

~~~bash
export RESOURCE_GROUP="rg-zt-enterprise-app-demo"
export WEB_APP_NAME="<terraform output web_app_name>"
export KEY_VAULT_NAME="<terraform output key_vault_name>"
export STORAGE_ACCOUNT_NAME="<terraform output storage_account_name>"
export APP_IDENTITY_CLIENT_ID="<terraform output app_identity_client_id>"
export APP_IDENTITY_PRINCIPAL_ID="<managed identity principal id>"
export LOG_ANALYTICS_WORKSPACE_ID="<terraform output log_analytics_workspace_id>"
~~~

Run:

~~~bash
./tests/enterprise-application/run-control-plane-tests.sh
~~~

## Runtime tests

Run these from the deployed workload or another host using the same managed identity with private network reachability.

~~~bash
pip install -r tests/enterprise-application/requirements.txt

export AZURE_CLIENT_ID="<managed-identity-client-id>"
export STORAGE_ACCOUNT_NAME="<storage-account>"
export TEST_CONTAINER="zero-trust-validation"
export TEST_BLOB="read-test.txt"

python tests/enterprise-application/runtime_storage_tests.py
~~~

## Release gate

The reference implementation passes the first negative-security gate only if public access is blocked, private endpoints are approved, least privilege is preserved, diagnostics are present, private DNS resolves correctly, approved reads work, and unauthorized writes fail.


## End-to-end validation runbook

For a full subscription-level lab test, including deliberate HA-ZT-001, HA-ZT-002, and HA-ZT-003 triggers plus approval-gated remediation, use:

**[Zero Trust end-to-end validation runbook](../../docs/validation/zero-trust-end-to-end-runbook.md)**
