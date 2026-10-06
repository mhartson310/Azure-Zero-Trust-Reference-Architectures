variable "location" {
  description = "Azure region for the reference deployment."
  type        = string
  default     = "westus2"
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
  default     = "rg-zt-enterprise-app-demo"
}

variable "prefix" {
  description = "Short naming prefix. Keep this lowercase/alphanumeric for globally named services."
  type        = string
  default     = "ztapp"
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "demo"
}

variable "allowed_admin_object_ids" {
  description = "Optional Entra object IDs that may be assigned Key Vault Administrator in the demo. Prefer PIM in production."
  type        = set(string)
  default     = []
}

variable "log_retention_days" {
  description = "Log Analytics retention."
  type        = number
  default     = 30
}
