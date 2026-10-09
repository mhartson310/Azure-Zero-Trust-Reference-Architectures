output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "web_app_name" {
  value = azurerm_linux_web_app.this.name
}

output "app_identity_client_id" {
  value = azurerm_user_assigned_identity.app.client_id
}

output "app_identity_principal_id" {
  value = azurerm_user_assigned_identity.app.principal_id
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_customer_id" {
  value = azurerm_log_analytics_workspace.this.workspace_id
}

output "private_endpoint_ids" {
  value = {
    web      = azurerm_private_endpoint.web.id
    keyvault = azurerm_private_endpoint.keyvault.id
    blob     = azurerm_private_endpoint.blob.id
  }
}
