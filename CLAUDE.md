# CLAUDE.md

## Project Overview

Learning / PoC Terraform configuration that provisions Azure Resource Groups per environment (dev / stg / prod) using Azure CLI authentication and local state.

## Key Constraints

- Authentication: Azure CLI only (`az login`)
- State: local (`terraform.tfstate`) — no remote backend
- Apply: local only — no CI/CD
- Environments: `dev`, `stg`, `prod`
- Region: `eastus`
- Remote State, CI/CD, Service Principal, and OIDC are out of scope

## Directory Structure

```
terraform/
  modules/
    resource_group/   # Reusable module: main.tf, variables.tf, outputs.tf
  envs/
    dev/              # Independent root module
    stg/
    prod/
Makefile
```

Each `envs/<env>/` is an independent Terraform root module with its own state file.

## Common Commands

```bash
make init ENV=dev       # terraform init
make fmt                # terraform fmt -recursive
make validate ENV=dev   # terraform validate
make plan ENV=dev       # terraform plan
make apply ENV=dev      # terraform apply
make destroy ENV=dev    # terraform destroy
```

`ENV` defaults to `dev` when omitted.

## Terraform Version & Provider

- Terraform `>= 1.6.0`
- AzureRM provider `~> 4.0`

## Git Rules

Commit: `*.tf`, `*.tfvars`, `.terraform.lock.hcl`, `SPEC.md`, `README.md`, `CLAUDE.md`, `Makefile`

Never commit: `.terraform/`, `*.tfstate`, `*.tfstate.*`

## Do Not

- Add a backend configuration block
- Hardcode secrets in `terraform.tfvars`
- Run `terraform apply` against prod with personal credentials in a real environment
