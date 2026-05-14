variable "environment" {
  description = "Environment name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
}

variable "databricks_workspace_name" {
  description = "Databricks workspace name."
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name (3-24 chars, lowercase alphanumeric, globally unique)."
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault name (3-24 chars, alphanumeric and hyphens, globally unique)."
  type        = string
}

variable "ai_foundry_name" {
  description = "Azure AI Foundry hub name."
  type        = string
}
