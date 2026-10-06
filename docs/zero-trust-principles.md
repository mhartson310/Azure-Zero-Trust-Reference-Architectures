# Zero Trust Principles for Azure

Zero Trust is an architectural strategy, not a product or SKU.

Microsoft's guidance centers on three principles:

## 1. Verify explicitly

Every request should be authenticated and authorized using the signals available at that point in the architecture.

In Azure, this commonly includes:

- Microsoft Entra identity
- user and workload risk
- device compliance
- Conditional Access
- location/network context
- application context
- resource sensitivity
- service/workload identity

**Architecture question:** What signals are used to make this access decision, and can the requester bypass them?

## 2. Use least privilege

Access should be limited to the smallest permission set, scope, and duration required.

Azure patterns include:

- RBAC scoped at the lowest practical boundary
- PIM-eligible instead of permanently active privilege
- JIT/JEA where applicable
- managed identities instead of stored credentials
- separate runtime and administrative identities
- separate ingestion/write identities from query/read identities
- data-level permissions in addition to platform permissions

**Architecture question:** What can this identity do if it is compromised?

## 3. Assume breach

Architect as though an identity, workload, device, or network segment will eventually be compromised.

Azure patterns include:

- workload segmentation
- Private Link / private endpoints
- deny-by-default network rules
- Azure Firewall / NSGs
- encryption in transit and at rest
- continuous monitoring
- Microsoft Defender for Cloud
- Microsoft Sentinel
- immutable backups / protected recovery paths
- resource locks and change control where appropriate

**Architecture question:** How far can a compromise spread before another control stops it?

---

## Applied Zero Trust model

This repository evaluates architecture across six control planes:

| Plane | Goal |
|---|---|
| Identity | Establish who or what is requesting access. |
| Privilege | Minimize what that identity can do. |
| Network | Limit where the request can travel. |
| Workload | Protect execution and application boundaries. |
| Data | Restrict and govern access to sensitive information. |
| Monitoring | Continuously validate whether controls behave as expected. |

A strong architecture requires all six.

A private network without strong identity is not Zero Trust.

MFA without least privilege is not Zero Trust.

RBAC without monitoring is not Zero Trust.

The value comes from **layered enforcement and continuous validation**.

## References

- https://learn.microsoft.com/azure/security/fundamentals/zero-trust
- https://learn.microsoft.com/security/zero-trust/azure-networking-overview
