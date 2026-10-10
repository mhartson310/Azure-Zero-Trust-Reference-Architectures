# Zero Trust — Architecture and Business Value Decisions

**Status: Decision examples for review, not approved production decisions.**

[Reusable framework](architecture-decision-framework/README.md) · [ADR template](architecture-decision-framework/ADR-template.md) · [Business-case template](architecture-decision-framework/business-case-template.md)

## Business context

Protect sensitive Azure workloads while reducing unnecessary access and making failures observable. The business case should measure **policy drift detection**, time to recognize unauthorized changes, verified access boundaries, and operator effort against actual baselines—not claim that Zero Trust delivers a universal percentage reduction in breaches.

## Decision scenarios

### ZT-ADR-001 — Private connectivity vs public endpoint with restrictions
- **Options:** public endpoint plus IP/network rules; private endpoint and private DNS; hybrid segmented access.
- **Trade-off:** private paths reduce direct exposure but create DNS, connectivity, operational, and cost dependencies.
- **Mandatory gates:** legitimate user connectivity, recovery access, identity enforcement, diagnostic logging, tested DNS and routing.
- **Decision hypothesis:** Prefer private connectivity for the protected reference workload, subject to validation.
- **Evidence:** [Terraform](../terraform/enterprise-application/README.md), [negative tests](../tests/enterprise-application/README.md).

### ZT-ADR-002 — Managed identity and least privilege vs long-lived secrets
- **Options:** static application secrets; user-assigned managed identity; workload federation where appropriate.
- **Trade-off:** identity lifecycle and Azure RBAC propagation versus credential storage/rotation and portability.
- **Mandatory gates:** scoped role assignments, no privilege escalation path, clear ownership, supported workload identity.
- **Decision hypothesis:** Prefer managed identity on supported Azure workloads, with explicit data-plane RBAC.
- **Evidence:** Terraform identity and RBAC definitions; negative authorization tests.

### ZT-ADR-003 — Sentinel response automation: alerting vs approval-gated remediation
- **Options:** manual investigation; automated triage; policy-gated remediation with independently verified target.
- **Trade-off:** faster response versus the impact of erroneous destructive actions.
- **Mandatory gates:** unique target identity, authenticated approver, narrow remediation scope, 404-aware outcome verification, audit trail, rollback.
- **Decision hypothesis:** Automate triage; treat destructive remediation as **not production-ready** pending hardening and Azure tests.
- **Evidence:** [Sentinel response work](https://github.com/mhartson310/Sentinel-KQL-Library/tree/main/deploy/playbooks/zero-trust), [evidence register](../docs/validation/evidence/README.md).

## Value and cost measurements

| Measure | Baseline | Proposed success criterion |
|---|---|---|
| Exposure state | Collect resource configuration inventory | Every scoped public endpoint state independently verified |
| Privileged role changes | Count audited changes per month | Every scoped test change detectable with correct target entity |
| Diagnostic coverage | Verify required sources/categories | Missing setting discovered and restored in approved lab scenario |
| Analyst burden | Capture manual triage minutes | Compare equivalent events with/without enriched incident context |
| TCO | Collect private endpoint, DNS, workspace ingestion, storage and Logic Apps pricing | Compare dated monthly ranges and projected log volumes |

No cost savings, production readiness, or reduction in incidents has been measured in this repository.

## Review gates

Architecture owner + SOC owner + identity/network owner + finance partner review. Revisit when connectivity, Azure costs, threat models, retention requirements, or tested detection quality change.
