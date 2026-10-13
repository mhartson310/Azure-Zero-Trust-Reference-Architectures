# Executive Decision Brief — Azure Zero Trust Enterprise Application

**Decision requested:** Approve a bounded, non-production control-validation pilot; set its budget and duration before execution.  
**Audience:** Security leadership, platform owner, and budget sponsor  
**Status:** PROPOSED — not a deployment approval or a report of tested controls

## 1. The Ask

Authorize a scoped lab to test private access, workload least privilege, audit visibility, and safe incident handling for the [reference architecture](../architecture/enterprise-application/README.md). Assign an accountable owner and approve a cost ceiling and time box **before** provisioning resources. Production rollout and destructive remediation are outside this request.

## 2. Why Now

The Terraform reference, test procedures, and detection patterns are documented, but [live Azure control-path evidence has not been recorded](validation/evidence/README.md). Before this design informs operational decisions, we need to show that denied access stays denied and security-relevant changes produce attributable telemetry.

## 3. What It Costs

**Budget: not yet priced.** Obtain current rates and scope for App Service, private endpoints/DNS, Key Vault, Storage, Log Analytics ingestion/retention, and any Sentinel/automation usage. Include engineer and reviewer hours, test identities, cleanup, and the platform/SOC work deferred during the pilot. No ROI or savings figure is asserted.

## 4. Cost of Inaction

Without the pilot, leadership cannot tell whether private-only access, restricted data-plane permissions, or detection/response paths operate as intended. If the reference is adopted without this evidence, important authorization or monitoring gaps could go unnoticed; the likelihood and financial impact are **not measured**.

## 5. What Happens Next

The architecture and security owners agree on pilot scope, acceptance tests, rollback, budget, and approvers. Execute **non-destructive** negative tests first, publish sanitized pass/fail evidence, and keep destructive remediation blocked pending the [documented safety fixes](validation/evidence/README.md) and independent approval.

**Decision gate:** No production-ready claim until evidence is reviewed.  
**Supporting detail:** [Architecture decisions](decision-framework/zero-trust-architecture-decisions.md) · [Control matrix](control-matrix.md) · [Validation evidence register](validation/evidence/README.md) · [Leadership threat summary](threat-model-leadership-summary.md).
