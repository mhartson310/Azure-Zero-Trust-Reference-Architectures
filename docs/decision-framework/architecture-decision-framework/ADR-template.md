# ADR-NNN — <Decision title>

**Status:** Proposed / Accepted / Superseded / Rejected  
**Decision owner:** <role>  
**Date:** YYYY-MM-DD  
**Review date / trigger:** <event or date>  
**Related business case:** <link>

## Business context and outcome
What problem exists? Who owns it? What observable metric changes if solved? State the **current baseline**, desired outcome, and what evidence is missing.

## Scope and assumptions
System boundary, data classes, users, dependencies, regulatory obligations, regions, nonfunctional requirements, timelines and unknowns.

## Options considered
| Option | Security/governance | Cost and complexity | Benefits | Risks |
|---|---|---|---|---|
| A — Current state / no change | | | | |
| B — Alternative | | | | |
| C — Alternative | | | | |

## Mandatory gates
- [ ] Authorization and least privilege
- [ ] Privacy, data classification and retention
- [ ] Regulatory/data-residency requirements
- [ ] Auditability, telemetry and incident response
- [ ] Reliability, rollback and ownership

**Any failure or unknown:** Escalate; do not treat scoring as approval.

## Decision and rationale
Decision, trade-offs, why alternatives were rejected, and the accountable approver. If unresolved, retain **Proposed** status.

## Financial and operational analysis
State workloads, volumes, assumptions, dated prices, cost ranges, migration effort, support/monitoring, sensitivity and opportunity cost. No fabricated ROI.

## Acceptance and evidence
| Criterion | How tested | Expected | Observed | Evidence link |
|---|---|---|---|---|
| | | | Not tested | |

## Validation plan and decision gates

Define validation **before implementation**. Separate a proposal from a proven decision.

### 1. Prerequisites and test environment

- Scope: <non-production subscription, tenant, workspace, region and assets, sanitized>
- Assumptions/dependencies: <data quality, identity, connectors, licensing, pricing>
- Test owner and independent reviewer: <roles>
- Safety boundaries: <least privilege, restricted scope, no customer data, cost caps>
- Rollback / recovery: <how to restore previous state>

### 2. Traceable acceptance tests

| Test ID | Requirement / hypothesis | Method (positive, negative, failure injection, benchmark) | Target threshold / expected result | Evidence artifact | Actual observation | Status |
|---|---|---|---|---|---|---|
| VAL-001 | <business outcome> | <measured pilot> | <target vs dated baseline> | <sanitized report> | NOT RUN | NOT RUN |
| VAL-002 | <security / authorization boundary> | <attempt unauthorized action> | <denied; no unauthorized access> | <logs, test result> | NOT RUN | NOT RUN |
| VAL-003 | <resilience / rollback> | <simulate failure and recover> | <recovery threshold> | <run history> | NOT RUN | NOT RUN |
| VAL-004 | <cost / TCO model> | <measured usage × dated rates> | <approved operating envelope> | <model + assumptions> | NOT RUN | NOT RUN |

Use **PASS / FAIL / BLOCKED / NOT RUN**. Avoid claiming PASS from static documentation or an expected-results column.

### 3. Stage gates

- **G0 — Decision completeness:** Sponsor, owner, alternatives (including do nothing), constraints and business baseline documented.
- **G1 — Feasibility:** Architecture, data/governance, security, compliance and pricing prerequisites reviewed.
- **G2 — Pilot readiness:** Test environment, safety controls, approvers, resource budget and rollback plan authorized.
- **G3 — Technical validation:** Positive/negative tests and resilience checks executed; results independently reviewed.
- **G4 — Business validation:** Outcome metrics and TCO measured against the baseline and accepted thresholds.
- **G5 — Operational acceptance:** Runbook, ownership, telemetry, incident response, exceptions and handover approved.

A failed mandatory security or regulatory gate **blocks approval regardless of an option score**.

### 4. Evidence and decision record

- Artifact location / revision / UTC timestamp: <links, commit, date>
- Test failures, exceptions, residual risks and corrective actions: <owner and due date>
- Reviewer sign-off: <role, date and disposition>
- Outcome: **PROPOSED / CONDITIONAL / APPROVED FOR PILOT / ACCEPTED / REJECTED**
- Claims explicitly *not* supported by evidence: <e.g. production validated, cost savings>
- Next review: <calendar date or triggering condition>

## Risks, mitigations, and exit plan
Document residual risk, responsible owner, exceptions, rollback and supplier portability.

## Review triggers
Changes in cost, user scale, threat model, vendors, data sensitivity, law, incident trends or measured outcomes.
