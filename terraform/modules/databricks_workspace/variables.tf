variable "name" {
  description = "Name of the Databricks workspace."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name to deploy the workspace into."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "sku" {
  description = "SKU tier: standard, premium, or trial."
  type        = string
  default     = "standard"
}

variable "tags" {
  description = "Tags applied to the workspace."
  type        = map(string)
  default     = {}
}
