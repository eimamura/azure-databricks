# azure-databricks

A learning / PoC Terraform configuration for managing Azure Resource Groups per environment (dev / stg / prod).

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.6.0
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed
- Access to an Azure subscription

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

## Directory Structure

```
terraform/
  modules/
    resource_group/   # Reusable Resource Group module
  envs/
    dev/              # dev environment
    stg/              # stg environment
    prod/             # prod environment
```

## How to Run

### Using Make (recommended)

```bash
make init ENV=dev
make fmt
make validate ENV=dev
make plan ENV=dev
make apply ENV=dev
```

### Using Terraform directly

```bash
cd terraform/envs/dev
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Repeat for `stg` and `prod`.

## Destroy

```bash
make destroy ENV=dev
# or
cd terraform/envs/dev && terraform destroy
```

## Notes

- State is stored locally (`terraform.tfstate`). Do not commit it to Git.
- Do not put secrets in `terraform.tfvars`.
- For production use, migrate to Remote Backend, CI/CD, and Service Principal.
