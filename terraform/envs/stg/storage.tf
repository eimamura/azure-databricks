module "storage_account" {
  source = "../../modules/storage_account"

  name                = var.storage_account_name
  resource_group_name = module.resource_group.name
  location            = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
