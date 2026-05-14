resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

resource "azurerm_storage_account" "this" {
  name                     = "${var.name}${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  account_kind             = "StorageV2"
  is_hns_enabled           = true # ADLS Gen2 for Databricks
  tags                     = var.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  name               = var.container_name
  storage_account_id = azurerm_storage_account.this.id
}
