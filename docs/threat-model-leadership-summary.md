# Leadership Threat Model Summary — Azure Zero Trust Enterprise Application

**System:** Azure Zero Trust enterprise application reference  
**Prepared for:** Security leadership, platform owner, and risk/budget sponsor  
**Assessment status:** DESIGN-LEVEL ONLY — no end-to-end live Azure security test evidence published  
**Confidence:** Moderate in the plausibility of the paths; **unverified** control effectiveness

## 1. What Would Someone Want From Us?

- **Sensitive application data and secrets:** content held in protected Storage and Key Vault services.
- **Control over access and the audit trail:** workload permissions, privileged role assignments, and diagnostic settings that govern who can reach assets and whether that access is visible.

## 2. How Would They Most Plausibly Get It?

**Path A — Compromised workload identity:** An attacker obtains a usable application identity, attempts to exercise or expand its permissions, then queries protected data or secrets. Private networking alone does not stop misuse by an already-authorized identity.

**Path B — Privilege and visibility tampering:** An attacker with sufficient privileges changes a role assignment or exposure setting, then disables or reroutes diagnostics to reduce the chance a harmful change is noticed. This is a *scenario to test*, not a recorded attack in this environment.

## 3. What Have We Already Done About It?

- **Path A — Partial (design coverage):** Terraform defines managed identity, restricted data roles, and private endpoints; negative tests are authored. There is **no published live Azure evidence** that the intended access boundaries hold. [Implementation](../terraform/enterprise-application/README.md) · [Tests](../tests/enterprise-application/README.md)
- **Path B — Open (operational proof):** Detection rules and response designs exist, but incident entity mapping, approval provenance, and exact remediation target handling need hardening and live tests. Treat automated destructive response as **not production-ready**. [Evidence blockers](validation/evidence/README.md)

## 4. What's Left, and What Would Closing It Cost?

1. **Priority 1 — Prove protected and denied paths.** Set up a capped lab; test public access, identity-based read/write boundaries, private DNS, and diagnostic delivery. **Cost/effort:** engineering and reviewer time plus metered Azure resources; estimate pending.
2. **Priority 1 — Prove safe incident handling.** Validate identity mapping and approval controls, distinguish failed reads from true deletion, and test remediation only after independent authorization. **Cost/effort:** engineering, SOC review, and lab telemetry; estimate pending.
3. **Priority 2 — Operational handover.** Assign owners, retain sanitized evidence, document rollback and recurring verification. **Cost/effort:** ongoing analyst/platform time; estimate pending.

**Leadership decision:** Fund scoping and controlled validation first; do not accept a risk as *covered* based on code or intended outcomes alone.  
**Technical basis:** [Architecture trust boundaries](../architecture/enterprise-application/README.md) · [Control matrix](control-matrix.md) · [Validation evidence register](validation/evidence/README.md).
