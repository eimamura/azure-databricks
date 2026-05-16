# Azure AI Foundry — Terraform Reference

## Resource Type Overview

Azure AI Foundry has multiple resource types with similar names that are easy to confuse.

| Resource | Provider | Type | Purpose |
|---|---|---|---|
| `azurerm_ai_foundry` | AzureRM | `Microsoft.MachineLearningServices/workspaces` kind=Hub | **Classic Hub (legacy). Do not use for new deployments.** |
| `azurerm_ai_foundry_project` | AzureRM | Project under the above | Same — do not use. |
| `azurerm_cognitive_account` | AzureRM | `Microsoft.CognitiveServices/accounts` kind=AIServices | **New Foundry resource. Use this.** |
| `azurerm_cognitive_account_project` | AzureRM | Project under the above | Foundry project |
| `azurerm_cognitive_deployment` | AzureRM | Deployment under the above | Model deployment |
| `azapi_resource` | AzAPI | Any ARM resource | Advanced Foundry config not yet supported by AzureRM (Connections, Agent standard setup, etc.) |

---

## Recommended Architecture

```
azurerm_cognitive_account          # Foundry account
  └─ azurerm_cognitive_account_project
      └─ azurerm_cognitive_deployment   # model deployment (optional)
```

Advanced features (Connections, Agent standard setup, BYO Storage, etc.) are not yet supported by the AzureRM provider. Use AzAPI for those.

---

## Minimal Terraform Implementation

### Foundry Account

```hcl
resource "azurerm_cognitive_account" "foundry" {
  name                = "aif-sample-dev"
  location            = "eastus"
  resource_group_name = "rg-sample-dev"

  kind     = "AIServices"
  sku_name = "S0"

  custom_subdomain_name         = "aifsampledev"   # globally unique, lowercase alphanumeric only, max 24 chars
  project_management_enabled    = true              # required to operate as a Foundry resource
  local_auth_enabled            = true              # set to false to disable API Key auth (Entra ID only)
  public_network_access_enabled = true              # suitable for dev; set to false in production

  identity {
    type = "SystemAssigned"
  }

  tags = { environment = "dev" }
}
```

### Foundry Project

```hcl
resource "azurerm_cognitive_account_project" "project" {
  name                 = "proj-sample-dev"
  cognitive_account_id = azurerm_cognitive_account.foundry.id
  location             = "eastus"

  identity {
    type = "SystemAssigned"
  }
}
```

### Model Deployment (optional)

```hcl
resource "azurerm_cognitive_deployment" "gpt4o_mini" {
  name                 = "gpt-4o-mini"
  cognitive_account_id = azurerm_cognitive_account.foundry.id

  sku {
    name     = "GlobalStandard"
    capacity = 1
  }

  model {
    format  = "OpenAI"
    name    = "gpt-4o-mini"
    version = "2024-07-18"
  }
}
```

---

## Module Design for This Project

### `terraform/modules/ai_foundry/`

- Manages `azurerm_cognitive_account` and `azurerm_cognitive_account_project` together.
- A `random_string` resource appends a 6-character suffix to the account name and `custom_subdomain_name` for global uniqueness.
- `custom_subdomain_name` is capped at 24 characters using `substr(..., 0, 24)`.
- The AzAPI provider is not used inside the module. It is kept in each env's `main.tf` for future advanced configuration.

### Module Variables

| Variable | Description |
|---|---|
| `name` | Base name for the account (random suffix is appended) |
| `resource_group_name` | Resource group name (AzureRM takes the name, not the ID) |
| `location` | Azure region |
| `project_name` | Name of the Foundry project |
| `tags` | Resource tags |

---

## Important Notes

### Do not use `azurerm_ai_foundry`

Despite the name, this resource creates a Classic Hub (`Microsoft.MachineLearningServices/workspaces` kind=Hub), which appears as "Azure AI hub" in the Portal. For new Foundry deployments, use `azurerm_cognitive_account` with `kind = "AIServices"`.

### `custom_subdomain_name` Constraints

- Must be globally unique across Azure.
- Lowercase alphanumeric characters only — no hyphens.
- Maximum 24 characters.

### `project_management_enabled = true` is Required

If this is left at the default (`false`), the resource will not function as a Foundry resource in the Portal and project creation will be disabled. This attribute can only be set to `true` when `kind = "AIServices"`.

### Features Not Yet Supported by AzureRM (as of May 2025)

Use AzAPI for the following:

- Connections (linking external services)
- Capability Host / Agent standard setup
- BYO Storage / Application Insights attachment
- Network Injection (injecting Agent Client into a subnet)

### Soft-Delete Name Collision

After `terraform destroy`, running `terraform apply` with the same name may fail because the resource is still in soft-deleted state (especially Key Vault). Be careful with repeated destroy/apply cycles in PoC environments.

---

## References

- [Azure AI Foundry resource type concepts](https://learn.microsoft.com/en-us/azure/ai-foundry/concepts/resource-types)
- [Create a Foundry resource with Terraform (official guide)](https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/create-resource-terraform)
- [azurerm_cognitive_account documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account)
- [Foundry Samples — official reference implementation](https://github.com/azure-ai-foundry/foundry-samples)
- [AVM Pattern Module (reference)](https://github.com/Azure/terraform-azurerm-avm-ptn-aiml-ai-foundry)
