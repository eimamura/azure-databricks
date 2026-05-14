terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

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
