variable "name" {
  description = "Storage account name (3-24 chars, lowercase alphanumeric only, globally unique)."
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
