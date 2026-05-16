variable "name" {
  description = "Storage account base name. Random suffix (6 chars) is appended; total must not exceed 24 chars, so max 18 chars here. Lowercase alphanumeric only."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 18 && can(regex("^[a-z0-9]+$", var.name))
    error_message = "Storage account name prefix must be 3-18 lowercase alphanumeric chars (a 6-char suffix is appended to stay within Azure's 24-char limit)."
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

variable "account_replication_type" {
  description = "Replication type: LRS, GRS, RAGRS, ZRS."
  type        = string
  default     = "LRS"
}

variable "container_name" {
  description = "ADLS Gen2 filesystem (container) name."
  type        = string
  default     = "data"
}

variable "tags" {
  description = "Tags applied to the storage account."
  type        = map(string)
  default     = {}
}
