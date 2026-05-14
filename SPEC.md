# SPEC.md

## Purpose

Create a basic Terraform configuration on Azure.

This SPEC assumes the following:

- Authentication uses Azure CLI
- State is managed locally
- Apply is also executed locally
- Three environments are provisioned: `dev`, `stg`, `prod`
- Azure region is `eastus`
- This is a learning / PoC configuration
- Remote State, CI/CD, Service Principal, and OIDC are out of scope

---

## Goal

Build a Terraform configuration that creates Azure Resource Groups per environment.

The final workflow should be executable as follows:

```bash
cd terraform/envs/dev
terraform init
terraform plan
terraform apply

cd terraform/envs/stg
terraform init
terraform plan
terraform apply

cd terraform/envs/prod
terraform init
terraform plan
terraform apply
```

---

## Prerequisites

The developer must be logged in with Azure CLI beforehand.

```bash
az login
```

The target subscription must be set.

```bash
az account set --subscription "<SUBSCRIPTION_ID>"
```

Terraform accesses Azure using the Azure CLI credentials (active subscription).

The following are **not** used in this setup:

- Service Principal
- OIDC
- Managed Identity
- Remote Backend
- CI/CD Apply

---

## Directory Structure

The following structure is created:

```
terraform/
  modules/
    resource_group/
      main.tf
      variables.tf
      outputs.tf

  envs/
    dev/
      main.tf
      variables.tf
      terraform.tfvars
      outputs.tf

    stg/
      main.tf
      variables.tf
      terraform.tfvars
      outputs.tf

    prod/
      main.tf
      variables.tf
      terraform.tfvars
      outputs.tf

Makefile
```

---

## Makefile

A `Makefile` is placed at the repository root to wrap common Terraform operations.

All targets accept an `ENV` variable (`dev`, `stg`, or `prod`).

### `Makefile`

```makefile
ENV ?= dev
DIR := terraform/envs/$(ENV)

.PHONY: init fmt validate plan apply destroy

init:
	cd $(DIR) && terraform init

fmt:
	terraform fmt -recursive terraform/

validate:
	cd $(DIR) && terraform validate

plan:
	cd $(DIR) && terraform plan

apply:
	cd $(DIR) && terraform apply

destroy:
	cd $(DIR) && terraform destroy
```

### Usage

```bash
make init ENV=dev
make fmt
make validate ENV=dev
make plan ENV=dev
make apply ENV=dev
make destroy ENV=dev
```

`ENV` defaults to `dev` when omitted.

---

## Design Principles

### modules

Place reusable Terraform modules under `modules/`.

For this setup, a minimal Resource Group module is created.

### envs

`envs/dev`, `envs/stg`, and `envs/prod` are each independent Terraform root modules.

Run `terraform init`, `terraform plan`, and `terraform apply` inside each environment folder.

### State

No backend is configured in this setup.

Each environment's state is stored locally in its own folder.

```
terraform/envs/dev/terraform.tfstate
terraform/envs/stg/terraform.tfstate
terraform/envs/prod/terraform.tfstate
```

### Provider

Uses the AzureRM provider.

Each environment's `main.tf` includes:

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

---

## Resource Group Module

### `terraform/modules/resource_group/variables.tf`

```hcl
variable "name" {
  description = "Name of the Azure Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region where the Resource Group will be created."
  type        = string
}

variable "tags" {
  description = "Tags applied to the Resource Group."
  type        = map(string)
  default     = {}
}
```

### `terraform/modules/resource_group/main.tf`

```hcl
resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
```

### `terraform/modules/resource_group/outputs.tf`

```hcl
output "name" {
  description = "Resource Group name."
  value       = azurerm_resource_group.this.name
}

output "id" {
  description = "Resource Group ID."
  value       = azurerm_resource_group.this.id
}

output "location" {
  description = "Resource Group location."
  value       = azurerm_resource_group.this.location
}
```

---

## dev Environment

### `terraform/envs/dev/variables.tf`

```hcl
variable "environment" {
  description = "Environment name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
}
```

### `terraform/envs/dev/main.tf`

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
```

### `terraform/envs/dev/terraform.tfvars`

```hcl
environment         = "dev"
location            = "eastus"
resource_group_name = "rg-sample-dev"
```

### `terraform/envs/dev/outputs.tf`

```hcl
output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_id" {
  value = module.resource_group.id
}
```

---

## stg Environment

### `terraform/envs/stg/variables.tf`

```hcl
variable "environment" {
  description = "Environment name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
}
```

### `terraform/envs/stg/main.tf`

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
```

### `terraform/envs/stg/terraform.tfvars`

```hcl
environment         = "stg"
location            = "eastus"
resource_group_name = "rg-sample-stg"
```

### `terraform/envs/stg/outputs.tf`

```hcl
output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_id" {
  value = module.resource_group.id
}
```

---

## prod Environment

### `terraform/envs/prod/variables.tf`

```hcl
variable "environment" {
  description = "Environment name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name."
  type        = string
}
```

### `terraform/envs/prod/main.tf`

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}
```

### `terraform/envs/prod/terraform.tfvars`

```hcl
environment         = "prod"
location            = "eastus"
resource_group_name = "rg-sample-prod"
```

### `terraform/envs/prod/outputs.tf`

```hcl
output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_id" {
  value = module.resource_group.id
}
```

---

## How to Run

### Using Make (recommended)

```bash
make init ENV=dev
make fmt
make validate ENV=dev
make plan ENV=dev
make apply ENV=dev
```

Repeat with `ENV=stg` and `ENV=prod` for other environments.

### Using Terraform directly

#### dev

```bash
cd terraform/envs/dev
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

#### stg

```bash
cd terraform/envs/stg
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

#### prod

```bash
cd terraform/envs/prod
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

---

## How to Destroy

### Using Make

```bash
make destroy ENV=dev
make destroy ENV=stg
make destroy ENV=prod
```

### Using Terraform directly

Run inside each environment folder.

```bash
cd terraform/envs/dev
terraform destroy
```

This deletes only the dev Resource Group managed by the dev state.

---

## Git Management Rules

Include in Git:

```
*.tf
*.tfvars
.terraform.lock.hcl
SPEC.md
README.md
```

Exclude from Git:

```
.terraform/
terraform.tfstate
terraform.tfstate.backup
```

Create a `.gitignore`:

```
.terraform/
*.tfstate
*.tfstate.*
crash.log
crash.*.log
*.tfvars.json
override.tf
override.tf.json
*_override.tf
*_override.tf.json
```

**Note:** Do not put secrets in `terraform.tfvars`.

The `terraform.tfvars` in this setup only contains the following, so it is safe to commit:

- `environment`
- `location`
- `resource_group_name`

---

## Notes

This configuration is for learning and PoC purposes.

For production, migrate to the following:

```
Local State
  ↓
Azure Storage Account Remote Backend

Local Apply
  ↓
CI/CD Apply

Azure CLI User Login
  ↓
Service Principal / OIDC
```

In production, do not run `terraform apply` against prod using a developer's personal Azure CLI credentials.

---

## Completion Criteria

The setup is complete when all of the following are satisfied:

- [ ] `Makefile` is created at the repository root
- [ ] `terraform/modules/resource_group` is created
- [ ] `terraform/envs/dev` is created
- [ ] `terraform/envs/stg` is created
- [ ] `terraform/envs/prod` is created
- [ ] `terraform init` succeeds in each environment
- [ ] `terraform fmt` succeeds in each environment
- [ ] `terraform validate` succeeds in each environment
- [ ] `terraform plan` succeeds in each environment
- [ ] Resource Group creation plan is displayed for each environment
- [ ] No backend configuration is included
- [ ] Azure CLI authentication is assumed
- [ ] Azure region is set to `eastus`
