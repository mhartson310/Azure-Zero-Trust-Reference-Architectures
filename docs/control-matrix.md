# Zero Trust Control Matrix

This matrix maps Zero Trust objectives to practical Azure capabilities and validation evidence.

| Objective | Azure capabilities | Implementation pattern | Validation evidence |
|---|---|---|---|
| Strong user authentication | Entra ID, MFA, Conditional Access | Require strong authentication and context-aware access | Sign-in logs, CA results |
| Privileged access control | PIM, RBAC | Eligible roles, approval, time-bounded elevation | PIM activation logs |
| Workload authentication | Managed Identity | Remove stored service credentials | Token-based auth, secret inventory |
| Application authorization | Entra app roles, RBAC, custom authorization | Authorize per workload/resource action | denied/allowed request logs |
| Network segmentation | VNets, NSGs, Azure Firewall, vWAN | Isolate workloads and deny unnecessary east-west traffic | connectivity tests, flow/firewall logs |
| Private service access | Private Link, private endpoints | Remove public service exposure where appropriate | DNS + path validation |
| Secret/key protection | Key Vault, Managed HSM | Centralized protected secret/key access | vault audit logs |
| Data governance | Purview | Classification, ownership, DLP/governance | labels, scans, policy results |
| Platform governance | Azure Policy, management groups | Guardrails at scale | compliance state |
| Cloud security posture | Defender for Cloud | posture recommendations + workload protection | recommendations/alerts |
| Threat detection | Sentinel, Defender XDR | central detection and correlation | analytics rules/incidents |
| Activity visibility | Azure Monitor, Log Analytics | central diagnostic logging | queryable telemetry |
| Admin-path protection | CA, PIM, PAW/hardened admin path | constrain privileged operations | privileged sign-ins + device claims |
| Resilience | Backup, recovery, locks | preserve recovery paths and reduce destructive impact | restore tests, recovery logs |

---

## Control design rules

1. **Do not rely on one control plane.** Identity, network, workload, and data controls should reinforce each other.
2. **Prefer identity-based access over shared secrets.**
3. **Remove standing privilege where practical.**
4. **Use private connectivity for high-value services where justified.**
5. **Centralize the telemetry required to prove enforcement.**
6. **Test denied paths, not only allowed paths.**
7. **Design monitoring while designing the architecture.**
