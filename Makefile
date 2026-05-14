ENV ?= dev
DIR := terraform/envs/$(ENV)

.PHONY: init fmt validate plan apply destroy

init:
	terraform -chdir=$(DIR) init

fmt:
	terraform fmt -recursive terraform/

validate:
	terraform -chdir=$(DIR) validate

plan:
	terraform -chdir=$(DIR) plan

apply:
	terraform -chdir=$(DIR) apply

destroy:
	terraform -chdir=$(DIR) destroy
