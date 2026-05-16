terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

resource "random_string" "suffix" {
  length  = 6
  lower   = true
  upper   = false
  numeric = true
  special = false
}

locals {
  account_name = "${var.name}-${random_string.suffix.result}"
  # customSubDomainName: lowercase alphanumeric, max 24 chars
  subdomain_name = substr("${replace(lower(var.name), "-", "")}${random_string.suffix.result}", 0, 24)
}

resource "azurerm_cognitive_account" "foundry" {
  name                = local.account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "AIServices"
  sku_name            = "S0"

  custom_subdomain_name         = local.subdomain_name
  project_management_enabled    = true
  local_auth_enabled            = true
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# azurerm_cognitive_account_project is the native resource for Foundry projects
resource "azurerm_cognitive_account_project" "project" {
  name                 = var.project_name
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = var.location

  identity {
    type = "SystemAssigned"
  }
}
