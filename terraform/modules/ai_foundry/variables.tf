variable "name" {
  description = "Azure AI Foundry hub name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "storage_account_id" {
  description = "Storage account resource ID to associate with the hub."
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault resource ID to associate with the hub."
  type        = string
}

variable "tags" {
  description = "Tags applied to the AI Foundry hub."
  type        = map(string)
  default     = {}
}
