# Zero Trust Validation Checklist

Use this checklist to test whether a Zero Trust architecture actually enforces its intended boundaries.

## Identity

- [ ] All interactive users authenticate through Microsoft Entra ID.
- [ ] Strong authentication is enforced for privileged and sensitive workflows.
- [ ] Conditional Access evaluates the intended signals.
- [ ] Legacy or bypass authentication paths are disabled where possible.
- [ ] Workload identities are inventoried and owned.

## Privilege

- [ ] Privileged roles are eligible/time-bound where practical.
- [ ] Standing Owner/Contributor assignments are minimized.
- [ ] PIM approvals and activation policies are configured for high-risk roles.
- [ ] Application runtime identities cannot perform platform administration.
- [ ] Read/query identities are separated from ingestion/write identities when appropriate.
- [ ] Break-glass accounts are protected, monitored, and tested.

## Network

- [ ] Workloads are segmented by trust and blast-radius requirements.
- [ ] Unnecessary east-west traffic is denied.
- [ ] Public endpoints are disabled where private access is required.
- [ ] Private DNS resolves correctly.
- [ ] Firewall/NSG paths have been validated from allowed and denied sources.
- [ ] Management traffic follows an approved admin path.

## Workloads

- [ ] Applications use managed identity where supported.
- [ ] Secrets are not embedded in code, images, or pipelines.
- [ ] Administrative interfaces are separated from user/runtime interfaces.
- [ ] Deployment identities have minimal permissions.
- [ ] Workload protection is enabled where required.

## Data

- [ ] Sensitive data is classified.
- [ ] Data access is enforced independently of network location.
- [ ] Data services use identity-based authorization where supported.
- [ ] Key/secret access is audited.
- [ ] Data export/exfiltration paths are understood.
- [ ] Retention and recovery requirements are defined.

## Monitoring

- [ ] Entra sign-in and audit events are retained.
- [ ] Azure Activity Logs are centralized.
- [ ] Critical resource diagnostics are enabled.
- [ ] Defender alerts reach an owned response process.
- [ ] Sentinel analytics cover identity, privilege, network, and workload control changes.
- [ ] Denied requests are visible.
- [ ] Correlation IDs / resource IDs allow investigations across services.

## Negative tests

- [ ] Unmanaged device cannot perform a protected workflow.
- [ ] Non-privileged identity cannot elevate without the approved path.
- [ ] Workload cannot reach a prohibited network segment.
- [ ] Application cannot reach a protected service through its public endpoint.
- [ ] Runtime identity cannot modify resources it only needs to read.
- [ ] Compromised workload identity cannot become a subscription administrator.
- [ ] Disabled/revoked access is reflected within the expected time.
- [ ] Logging failure is detectable.

## Release gate

Do not call the architecture Zero Trust-ready if any of the following remain true:

- authorization can be bypassed by changing network location;
- long-lived broad privilege is required for normal operations;
- one workload compromise provides unrestricted lateral movement;
- sensitive services remain publicly reachable despite a private-only design requirement;
- critical access decisions cannot be reconstructed from telemetry;
- privileged changes can occur without detection or audit.
