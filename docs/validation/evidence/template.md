# Zero Trust validation report — YYYY-MM-DD

**Status:** NOT RUN / PARTIAL / FAILED / VERIFIED (select based on actual evidence)
**Tester:** [name/role or redacted]
**Azure environment:** Disposable, isolated test subscription/resource group
**UTC start/end:** [time]
**Code revision(s):** [commit hashes]
**Evidence storage:** [internal protected location; do not publish sensitive URI]

## Scope and safety
- Lab-only subscription/resource group confirmed: [yes/no]
- Remediation managed identity limited to intended test scope: [yes/no]
- Approval personnel and authorization captured: [yes/no]
- Cleanup/recovery plan approved: [yes/no]

## Results

| Test ID | Expected | Observed | PASS / FAIL / NOT RUN | Redacted evidence |
|---|---|---|---|---|
| TF-001 | Terraform validation succeeds | | NOT RUN | |
| ZT-NEG-001 | Public access disabled | | NOT RUN | |
| ZT-NEG-002 | Private endpoints approved | | NOT RUN | |
| ZT-NEG-003 | Workload least privilege | | NOT RUN | |
| ZT-NEG-004 | Diagnostic destinations correct | | NOT RUN | |
| ZT-NEG-005 | Private DNS resolves privately | | NOT RUN | |
| ZT-NEG-006 | Allowed blob read works | | NOT RUN | |
| ZT-NEG-007 | Unauthorized write denied | | NOT RUN | |
| HA-ZT-002 | RBAC create -> incident -> labels/task | | NOT RUN | |
| RBAC-GATE | No approval -> no delete | | NOT RUN | |
| RBAC-VERIFY | Approved lab target removed and explicit 404 confirmed | | NOT RUN | |
| HA-ZT-003 | Diagnostic change -> incident -> task | | NOT RUN | |
| DIAG-GATE | No approval -> no write | | NOT RUN | |
| DIAG-VERIFY | Approved baseline restored and checked | | NOT RUN | |
| HA-ZT-001 | Controlled exposure drift detected | | NOT RUN | |
| CLEANUP | All disposable lab resources removed | | NOT RUN | |

## Findings and deviations

[Include actual errors, query-schema differences, ID mapping problems, timing delays, and deviations. Do not turn expected results into observed results.]

## Independent verification

[Document commands/queries used to verify state separately from the playbook's own success output.]

## Sanitization review

- [ ] Tenant/subscription IDs and resource IDs anonymized
- [ ] User/principal identifiers, IP addresses, and incident IDs redacted where sensitive
- [ ] Credentials, tokens, secrets, and internal URLs absent
- [ ] No customer/workload data present
- [ ] Screenshots reviewed
- [ ] Claims match recorded proof

## Decision

**Production-ready:** NO (until proven and approved)

**Next work:** [issues, owners, retest date]
