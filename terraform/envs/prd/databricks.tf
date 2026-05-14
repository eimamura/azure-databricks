module "databricks_workspace" {
  source = "../../modules/databricks_workspace"

  name                = var.databricks_workspace_name
  resource_group_name = module.resource_group.name
  location            = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
