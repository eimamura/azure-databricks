variable "name" {
  description = "Key Vault name (3-24 chars, alphanumeric and hyphens, globally unique)."
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

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "sku_name" {
  description = "Key Vault SKU: standard or premium."
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags applied to the Key Vault."
  type        = map(string)
  default     = {}
}
