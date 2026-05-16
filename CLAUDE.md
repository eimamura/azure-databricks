# CLAUDE.md

## Project Overview

Learning / PoC Terraform configuration that provisions Azure Resource Groups per environment (dev / stg / prd) using Azure CLI authentication and local state.

## Key Constraints

- Authentication: Azure CLI only (`az login`)
- State: local (`terraform.tfstate`) — no remote backend
- Apply: local only — no CI/CD
- Environments: `dev`, `stg`, `prd`
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
    prd/
Makefile
```

Each `envs/<env>/` is an independent Terraform root module with its own state file.

## File Splitting Rule

Do **not** put all module calls in `main.tf`. Split by resource concern:

```
envs/<env>/
  main.tf           # provider + data sources + resource_group only
  <resource>.tf     # one file per resource or related resource group
  variables.tf      # all variable declarations
  outputs.tf        # all output declarations
  terraform.tfvars
```

When adding a new module, create a new `<resource>.tf` file — do not append to `main.tf`.

## Random Suffix Rule

Any resource that requires a globally unique Azure name must generate a random suffix **inside the module** using `random_string` (length=6, lowercase alphanumeric). Do not manage uniqueness from the environment layer. Check Azure docs for each resource to determine if a globally unique name is required.

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

## Terraform Version & Providers

- Terraform `>= 1.6.0`
- AzureRM provider `~> 4.0`
- Random provider `~> 3.0` (required when any module uses `random_string`)

## Git Rules

Commit: `*.tf`, `*.tfvars`, `.terraform.lock.hcl`, `SPEC.md`, `README.md`, `CLAUDE.md`, `Makefile`

Never commit: `.terraform/`, `*.tfstate`, `*.tfstate.*`

## Commenting Out a Module

When a module call is commented out in `<resource>.tf`, its corresponding outputs in `outputs.tf` must also be commented out. Terraform will error if `outputs.tf` references a module that is not declared.

Always comment/uncomment both files together.

## Do Not

- Add a backend configuration block
- Hardcode secrets in `terraform.tfvars`
- Run `terraform apply` against prd with personal credentials in a real environment
