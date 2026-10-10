# Architecture Decision & Business Value Framework

A reusable, vendor-neutral structure for explaining **why an architecture should exist**, how alternatives are compared, and what evidence would justify adoption.

**Decision flow:** Business problem → Requirements and constraints → Options (including do nothing) → Security and governance gates → Cost/TCO → Decision → Validation → Review trigger.

## How to use

1. Copy [ADR template](ADR-template.md) and [business-case template](business-case-template.md) into the workload repository.
2. Name a specific decision owner and stakeholders. Mark decisions **proposed** until reviewed.
3. Define measurable outcomes and an explicit baseline; record unknowns as unknown.
4. Compare at least two credible options, including maintaining the current state where reasonable.
5. Apply mandatory security, privacy, regulatory, and data-residency gates *before* weighted scoring. A high score cannot override a failed mandatory gate.
6. Estimate cost ranges using actual workload assumptions and dated vendor prices; separate implementation, operations, data transfer, monitoring, training and retirement.
7. Specify acceptance tests and a rollback path. Do not assert the implementation is production-validated without captured results.
8. Revisit when risk, pricing, scale, capabilities or compliance conditions change.

## Evaluation dimensions

| Dimension | Questions and evidence |
|---|---|
| Business value | Whose problem, measurable baseline, target outcome, owner and value horizon? |
| Operational fit | Platform skills, integration effort, reliability, support burden, exit strategy? |
| Security | Data exposure, trust boundaries, authorization, privileged access, containment, detection? |
| Governance | Data classification, retention, auditability, vendor/subprocessor, regulatory constraints? |
| Financials | Build/run cost, vendor charges, telemetry, incident workload, opportunity cost, switching cost? |
| Verification | Testable acceptance criteria, required artifacts, operational metrics and thresholds? |

## Optional comparison score

Only after mandatory gates pass, score each dimension from 1–5 (5 is better) and state weights explicitly. Suggested **illustrative** weights:

- Business value: 25%
- Security/risk posture: 25%
- Operational fit: 20%
- Governance: 15%
- Cost efficiency: 15%

Document the rationale for any weighting changes. A score is a discussion aid, **not a substitute for architecture judgment or measured financial value**.

## Definition of useful evidence

| Claim | Acceptable supporting evidence |
|---|---|
| Deployable | Inspected IaC, successful static validation, documented prerequisites |
| Functionally tested | Repeatable test with dated, sanitized pass/fail output |
| Secure against a scenario | Negative test plus relevant scope and limitations |
| Lower-cost option | Dated TCO model and assumptions, sensitivity analysis |
| Measurable business benefit | Baseline and observed post-change metrics; attributable outcomes |
| Production-ready | Operational, security, privacy, resilience and business acceptance sign-off |

**Do not convert an expected outcome into a reported result.**

## Related implementations

- [Zero Trust decisions](../zero-trust-architecture-decisions.md)
- [Secure enterprise RAG decisions](https://github.com/mhartson310/Azure-Secure-Enterprise-RAG/blob/main/docs/decision-framework/README.md)
- [Sentinel operating model decisions](https://github.com/mhartson310/Sentinel-KQL-Library/blob/main/docs/decision-framework/README.md)
