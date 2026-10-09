# Zero Trust validation evidence

**Current state: NOT YET END-TO-END VALIDATED IN AZURE.**

This directory is an evidence framework, not a success report. The published code, templates, and runbook are inspectable; no Azure incident, playbook execution, control-plane remediation, or negative-security result has been supplied for this repository yet.

## What would count as proof

| Stage | Required evidence | Status |
|---|---|---|
| Terraform | CLI `fmt`, `validate`, plan summary, resulting resource inventory | Not recorded |
| Baseline controls | Output of ZT-NEG-001 to ZT-NEG-004 | Not recorded |
| Private data path | VNet-local private DNS + read-allowed/write-denied results | Not recorded |
| HA-ZT-002 | Test RBAC change, KQL match, incident ID, entity-mapping screenshot | Not recorded |
| First-stage SOAR | Matching automation-rule execution, labels, task, comment | Not recorded |
| RBAC safety gate | Without approval: no role assignment deletion | Not recorded |
| RBAC remediation | With approval: exact lab-scoped assignment removed, independently checked | Not recorded |
| HA-ZT-003 | Test diagnostic-settings event and incident | Not recorded |
| Diagnostic safety gate | Without approval: diagnostic setting remains unchanged | Not recorded |
| Diagnostic restoration | With approval: expected target, destination and categories restored | Not recorded |
| HA-ZT-001 | Disposable resource change triggers a correctly attributed incident | Not recorded |
| Cleanup | Resource inventory before/after, lab resources removed | Not recorded |

## Evidence format

Copy [template.md](template.md) to a new, dated report **after** an actual run. Record the subscription only in a private evidence store; for the public repository use a sanitized identifier or omit it. Include test ID, UTC time, expected and observed behavior, actual pass/fail status, and redacted artifacts.

**Never claim PASS based on an expected-result block in a runbook.** A GitHub Actions YAML or a successful static syntax check alone does not show a real Azure incident or successful live remediation.

## Security of published artifacts

Before uploading, remove tenant IDs, subscription IDs, principal object IDs, IP addresses, incident identifiers that disclose tenant context, authorization headers, bearer tokens, connection strings, access keys, secret values, prompts, customer data and personnel details. Screenshots may also contain resource names that disclose sensitive context.

Keep originals in a protected internal location. Publish only a short sanitized technical write-up, representative safe excerpts, and test methodology.

## Safety and known validation blockers

1. **Do not attempt destructive automation until the incident entity mapping is proven to carry the exact role-assignment or diagnostic-setting ARM resource ID.** Current analytic rules map the AzureActivity `ResourceId` column, whose shape must be checked against actual events. A mismatch can block the playbooks or cause unexpected target selection.
2. **Do not rely solely on an incident label as strong authorization.** Restrict which identities can apply approval labels or manually run playbooks. Add target allowlisting, role-definition checks, explicit approver identity validation and immutable decision logging before production use.
3. **Do not treat a failed GET as proof of deletion.** A 403, timeout, expired token, or service error is different from an expected 404. HA-ZT-002's current playbook must be hardened to distinguish these before a real deletion test is counted as PASS.
4. **Do not assume Key Vault or Storage logging can be restored from a generic template.** Validate the original diagnostic-setting name, exact category configuration, destination, and resource-level support first. HA-ZT-003's present second-stage template does not reproduce an arbitrary tenant baseline.
5. The analytics-rule Bicep, Logic App connector bindings and automation rules need actual tenant deployment and contract testing; static JSON parse or Bicep compilation is only preliminary validation.
6. Run in a dedicated test scope with explicit cost limits and a cleanup plan; keep rules and automation disabled until reviewed.

## Execution order

1. Read the [end-to-end runbook](../zero-trust-end-to-end-runbook.md) and its limitations.
2. Validate Terraform and shell scripts locally.
3. Deploy disposable lab resources and confirm baseline diagnostics.
4. Exercise **non-destructive, no-approval** paths first and record outputs.
5. Inspect entity IDs and automation permissions, then harden identified gaps.
6. Only after independent review, perform narrowly scoped remediation tests.
7. Record results in a dated template and publish sanitized evidence.

## Related artifacts

[Architecture](../../../architecture/enterprise-application/README.md) · [Terraform](../../../terraform/enterprise-application/README.md) · [Negative tests](../../../tests/enterprise-application/README.md) · [Detections and playbooks](https://github.com/mhartson310/Sentinel-KQL-Library)
