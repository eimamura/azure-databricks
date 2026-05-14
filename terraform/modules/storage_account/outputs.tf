output "id" {
  description = "Storage account resource ID."
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "primary_dfs_endpoint" {
  description = "Primary DFS endpoint for ADLS Gen2 access."
  value       = azurerm_storage_account.this.primary_dfs_endpoint
}

output "primary_access_key" {
  description = "Primary access key."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true
}

output "container_name" {
  description = "ADLS Gen2 filesystem name."
  value       = azurerm_storage_data_lake_gen2_filesystem.this.name
}
