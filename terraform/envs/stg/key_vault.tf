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
