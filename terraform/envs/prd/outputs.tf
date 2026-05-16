output "resource_group_name" {
  value = module.resource_group.name
}

output "resource_group_id" {
  value = module.resource_group.id
}

# output "databricks_workspace_id" {
#   value = module.databricks_workspace.id
# }

# output "databricks_workspace_url" {
#   value = module.databricks_workspace.workspace_url
# }

output "storage_account_name" {
  value = module.storage_account.name
}

output "storage_primary_dfs_endpoint" {
  value = module.storage_account.primary_dfs_endpoint
}

output "key_vault_id" {
  value = module.key_vault.id
}

output "key_vault_uri" {
  value = module.key_vault.uri
}

output "ai_foundry_id" {
  value = module.ai_foundry.id
}

output "ai_foundry_principal_id" {
  value = module.ai_foundry.principal_id
}

output "ai_foundry_endpoint" {
  value = module.ai_foundry.endpoint
}

output "ai_foundry_project_id" {
  value = module.ai_foundry.project_id
}
