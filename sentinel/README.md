# Microsoft Sentinel Integration

Zero Trust depends on continuous validation.

This folder will contain hunting queries and analytics-rule candidates that test whether the architecture is behaving as intended.

## Priority detection areas

### Identity

- repeated failed/blocked Conditional Access events;
- legacy authentication success;
- risky sign-ins;
- break-glass activity.

### Privilege

- PIM activation outside normal patterns;
- privileged role assigned permanently;
- privileged role assigned outside change window;
- service principal granted high-impact application role.

### Network

- NSG opened to the internet;
- public IP attached to protected workload;
- private endpoint removed or public access re-enabled;
- firewall policy weakened.

### Platform governance

- Azure Policy assignment removed;
- policy exemption created;
- Defender for Cloud plan disabled;
- diagnostic settings removed.

### Data / secrets

- Key Vault access granted followed by unusual secret access;
- storage anonymous access enabled;
- unexpected data egress patterns.

## Integration with Sentinel-KQL-Library

Reusable KQL should be mirrored into:

https://github.com/mhartson310/Sentinel-KQL-Library

This repository remains the canonical source for Zero Trust architecture context and control intent. The Sentinel KQL Library remains the reusable detection-engineering collection.


## Available detection packs

### Enterprise Application

The first implementation is available at:

**[Enterprise Application detection pack](enterprise-application/README.md)**

It includes hunting/analytics-rule candidates for:

- protected-service public exposure changes;
- privileged RBAC assignments;
- diagnostic settings changes;
- Key Vault access anomalies;
- Conditional Access failure spikes.

These detections pair directly with the [Terraform enterprise application implementation](../terraform/enterprise-application/README.md).
