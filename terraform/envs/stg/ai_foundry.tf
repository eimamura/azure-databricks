module "ai_foundry" {
  source = "../../modules/ai_foundry"

  name              = var.ai_foundry_name
  resource_group_name = module.resource_group.name
  location          = var.location
  project_name      = var.ai_foundry_project_name

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
