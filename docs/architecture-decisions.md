# Architecture Decisions

Zero Trust requires architecture decisions, not just control selection.

Use this document as the starting ADR register for this repository.

## ADR-001 — Private Link vs public service endpoints

**Question:** Should a service remain publicly reachable with identity controls, or require Private Link?

**Prefer Private Link when:**

- the service contains sensitive or regulated data;
- policy requires private connectivity;
- the workload already has private network integration;
- public exposure adds no required business capability.

**Tradeoffs:**

- private DNS complexity;
- network dependency;
- CI/CD runner reachability;
- troubleshooting overhead;
- additional cost.

**Validation:** Confirm the application cannot reach the service through a public endpoint when the design requires private-only access.

---

## ADR-002 — System-assigned vs user-assigned managed identity

**System-assigned identity**

Use when identity lifecycle should match one Azure resource.

**User-assigned identity**

Use when identity needs to survive workload replacement, be shared intentionally, or be pre-authorized before compute deployment.

**Zero Trust consideration:** Sharing identities increases blast radius. Reuse should be deliberate.

---

## ADR-003 — Standing RBAC vs PIM-eligible access

Use PIM-eligible roles for high-impact administrative access where operationally feasible.

Standing access should have an explicit justification.

**Validation:** Review active vs eligible privileged role assignments and alert on unexpected permanent elevation.

---

## ADR-004 — Hub-spoke vs Azure Virtual WAN

**Hub-spoke**

Useful when teams need explicit centralized network architecture and custom routing/inspection patterns.

**Virtual WAN**

Useful when global transit, branch connectivity, scalable hub management, or Microsoft-managed routing simplify the design.

**Zero Trust question:** Which design most clearly enforces segmentation, inspection, and ownership boundaries?

---

## ADR-005 — Central vs workload-specific Log Analytics

Centralization improves correlation and security operations.

Workload separation may be required for:

- data residency;
- ownership;
- regulatory boundaries;
- scale;
- retention differences.

**Decision rule:** Centralize security telemetry logically even when physical workspaces must remain separate.

---

## ADR-006 — Policy deny vs audit-first rollout

New controls often start in Audit/AuditIfNotExists mode.

Move to Deny/DeployIfNotExists after:

1. discovering current state;
2. identifying exceptions;
3. testing remediation;
4. assigning ownership;
5. proving deployment pipelines remain functional.

Zero Trust does not require breaking production to prove enforcement.
