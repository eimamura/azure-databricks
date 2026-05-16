resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "azurerm_key_vault" "this" {
  name                = "${var.name}-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  # Minimum retention to avoid soft-delete name collisions on destroy/apply cycles.
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  tags = var.tags
}
