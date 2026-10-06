# Terraform — Zero Trust Enterprise Application

This Terraform reference implementation turns the Enterprise Application architecture into deployable Azure resources.

## What it deploys

- Resource Group
- Log Analytics workspace
- Application Insights
- VNet with:
  - App Service integration subnet
  - Private Endpoint subnet
- NSG association
- Linux App Service
- User-assigned Managed Identity
- Key Vault with RBAC authorization
- Storage Account with Entra/OAuth-first access
- Private Endpoints for:
  - App Service
  - Key Vault
  - Blob Storage
- Private DNS zones + VNet links
- RBAC for the workload identity
- Diagnostic settings

## Zero Trust controls represented

| Principle | Implementation |
|---|---|
| Verify explicitly | Entra-backed workload identity; application auth is expected at the app layer |
| Least privilege | Managed Identity + scoped Storage Blob Data Reader and Key Vault Secrets User |
| Assume breach | Public access disabled on App Service, Key Vault, and Storage; Private Link used for service access |
| Continuous validation | Log Analytics, Application Insights, diagnostic settings |

## Important identity boundary

This Terraform does **not** silently create Conditional Access or PIM policy.

Those are tenant-level identity controls with their own governance, licensing, emergency-access, rollout, and exclusion requirements.

The application should be protected with Microsoft Entra authentication and Conditional Access appropriate to your tenant.

For privileged administration, prefer **PIM-eligible** roles rather than permanent assignments.

## Deploy

```bash
cd terraform/enterprise-application
cp terraform.tfvars.example terraform.tfvars

terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```

## Connectivity expectation

The App Service public endpoint is disabled.

Access to the app therefore requires network reachability to the VNet/private endpoint through an approved path such as:

- peered VNet;
- VPN / ExpressRoute;
- internal Application Gateway / approved ingress tier;
- another private corporate network path.

## Validation after deployment

Test these conditions deliberately:

1. App Service public access is unavailable.
2. Key Vault public access is unavailable.
3. Storage public access is unavailable.
4. App resolves private service names through Azure Private DNS.
5. App accesses Storage using the managed identity.
6. App accesses Key Vault using the managed identity.
7. The app identity cannot write to Blob Storage unless you explicitly grant that role.
8. A normal user cannot administer Key Vault.
9. Diagnostic data reaches Log Analytics.
10. Removing a private endpoint breaks the intended private-only path.

## Production notes

This is a reference implementation, not a complete enterprise landing zone.

Add or adapt:

- WAF / Application Gateway or Front Door architecture as required;
- enterprise DNS integration;
- central firewall/inspection;
- Defender for Cloud plans;
- backup/recovery controls;
- App Service authentication configuration;
- deployment slots;
- resource locks;
- enterprise policy assignments;
- workload-specific data services;
- approved CI/CD identities.

The design goal is to show the **control path**, not hide complexity.
