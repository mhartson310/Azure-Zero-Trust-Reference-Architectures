# Enterprise Application — Sentinel Detections

These KQL queries support the Zero Trust Enterprise Application reference architecture.

They focus on **control changes and failure paths** rather than generic malware detection.

## Detections

| Query | Security question |
|---|---|
| [Public network access enabled](public-network-access-enabled.kql) | Did someone re-enable public exposure on a protected service? |
| [Privileged RBAC assignment created](privileged-rbac-assignment-created.kql) | Was a high-impact Azure role granted unexpectedly? |
| [Diagnostic settings changed](diagnostic-settings-changed.kql) | Was security telemetry weakened or removed? |
| [Key Vault access anomaly](key-vault-access-anomaly.kql) | Is a principal performing unusual Key Vault access activity? |
| [Conditional Access failure spike](conditional-access-failure-spike.kql) | Is one identity repeatedly failing access policy? |

## Operating model

1. Run each query as a hunting query first.
2. Baseline your environment.
3. Add approved automation/change identities to watchlists or filters.
4. Tune thresholds.
5. Promote stable logic into scheduled Sentinel analytics rules.
6. Attach investigation steps to each alert.

A detection is an **investigation trigger**, not automatic proof of compromise.


## Canonical reusable KQL

The architecture-local examples above stay close to the reference design.

The reusable, tuned KQL versions are maintained in the **Sentinel KQL Library**:

**[Zero Trust Enterprise Application detection pack](https://github.com/mhartson310/Sentinel-KQL-Library/tree/main/kql-queries/zero-trust/enterprise-application)**

That pack currently includes:

- protected-service exposure changes;
- privileged RBAC assignment creation;
- diagnostic-setting changes;
- Key Vault access anomalies;
- Conditional Access failure spikes.

Use this repository for **architecture context, deployment, and validation**. Use the Sentinel KQL Library as the **canonical detection-engineering collection**.


## Deployable analytics rules

The production-oriented Bicep deployment package is maintained in the Sentinel KQL Library:

**[Deploy HA-ZT-001 through HA-ZT-003 with Bicep](https://github.com/mhartson310/Sentinel-KQL-Library/tree/main/deploy/bicep/zero-trust-analytics)**

The package deploys the three rules as Microsoft Sentinel Scheduled analytics rules with severity, MITRE mappings, scheduling, entity mappings, custom details, incident creation, and incident grouping.


## Automated response

The Sentinel KQL Library now also contains the SOAR layer for HA-ZT-001 through HA-ZT-003:

**[Zero Trust automated response + playbooks](https://github.com/mhartson310/Sentinel-KQL-Library/tree/main/deploy/playbooks/zero-trust)**

The package adds incident-triggered Logic Apps plus Sentinel automation rules for labeling, task creation, and playbook execution. The first version deliberately automates triage and analyst guidance rather than destructive remediation.


## Conditional remediation

For confirmed unauthorized changes, the Sentinel KQL Library now includes a second-stage response layer:

**[Approval-gated conditional remediation](https://github.com/mhartson310/Sentinel-KQL-Library/tree/main/deploy/playbooks/zero-trust/conditional-remediation)**

The playbooks require explicit analyst approval plus target validation before they delete an unauthorized RBAC assignment or restore the reference diagnostic baseline. They then validate the resulting state and update the incident.
