module "key_vault" {
  source = "../../modules/key_vault"

  name                = var.key_vault_name
  resource_group_name = module.resource_group.name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

module "ai_foundry" {
  source = "../../modules/ai_foundry"

  name                = var.ai_foundry_name
  resource_group_name = module.resource_group.name
  location            = var.location
  storage_account_id  = module.storage_account.id
  key_vault_id        = module.key_vault.id

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
