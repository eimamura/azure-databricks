variable "name" {
  description = "Key Vault base name. Random suffix (-xxxxxx) is appended; total must not exceed 24 chars, so max 17 chars here."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 17
    error_message = "Key Vault name must be 3-17 chars (a 7-char suffix '-xxxxxx' is appended to stay within Azure's 24-char limit)."
  }
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
