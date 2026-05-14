resource "azurerm_ai_foundry" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  storage_account_id  = var.storage_account_id
  key_vault_id        = var.key_vault_id
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}
