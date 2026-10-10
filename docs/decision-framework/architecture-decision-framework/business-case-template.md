# Business case — <Initiative>

**Sponsor:** <role> · **Owner:** <role> · **Stage:** Discovery / Pilot / Scale · **Date:** YYYY-MM-DD

## Problem and opportunity
Describe the decision to make, impacted teams, alternatives including **do nothing**, and consequences of inaction.

## Baseline and target
| Metric | Baseline (source, date) | Target | Measurement owner | Timing |
|---|---|---|---|---|
| | Unknown | Proposed | | |

## Business value hypothesis
Distinguish hard-dollar savings, productivity, risk avoidance and qualitative outcomes. Avoid double counting and unsupported monetization of risk.

## Use-case prioritization
Rate 1–5 and explain: business value, implementation complexity, data readiness, security/compliance risk and strategic fit. A low-risk score is not a compliance waiver.

## Cost/TCO assumptions
| Driver | Quantity / assumption | Unit rate/date | Monthly/annual range | Sensitivity |
|---|---|---|---|---|
| Platform/model/infrastructure | | | TBD | |
| Integration, migration, people | | | TBD | |
| Telemetry, security and governance | | | TBD | |
| Ongoing support and incident response | | | TBD | |
| Exit/portability | | | TBD | |

## Options and decision gates
Reference relevant ADRs. Include privacy, security, resilience, and operational acceptance.

## Pilot / validation plan
Specify sample size, duration, success thresholds, rollback and how outcomes will be measured. Mark all unrun tests as **NOT TESTED**.

## Business-value validation and release gates

Use this in addition to the [ADR's technical validation and stage-gate model](ADR-template.md).

| Gate | Evidence required | Accountable reviewer | Observed result | Status |
|---|---|---|---|---|
| B0 — Baseline | Dated and attributable pre-change metrics | Business owner | Not measured | NOT RUN |
| B1 — Feasibility | Data readiness, security/privacy approval, delivery and rollback plan | Architecture + security | Not reviewed | NOT RUN |
| B2 — Pilot | Representative sample, control group or baseline comparison, defined success thresholds | Business sponsor | Not run | NOT RUN |
| B3 — TCO | Usage-based estimate with dated rates, recurring cost and sensitivity | Finance partner | Not validated | NOT RUN |
| B4 — Benefit realization | Post-change observed outcomes, costs, operational impact and exceptions | Business + finance | Not observed | NOT RUN |
| B5 — Go/no-go | Recorded accept/defer/reject decision and residual risks | Named approver | No decision | NOT RUN |

- Treat forecast savings, time reduction, risk reduction, and model quality as **hypotheses** until observed.
- Preserve source dates, sample sizes, definitions, limitations, and links to sanitized evidence.
- A failed mandatory security, privacy, or regulatory gate is an explicit **no-go**, independent of financial benefit.
- Track **PASS / FAIL / BLOCKED / NOT RUN**, not a false binary completion checkbox.
- Review again if scope, volumes, pricing, vendors, data classification, or critical risks change.

## Stakeholders and review
Decision owner, finance partner, security/compliance reviewer, business sponsor, and revisit triggers.

## Decision
Proposed / Approved / Deferred / Rejected. Record rationale and date; never imply approval from an illustrative template.
