output "id" {
  description = "Databricks workspace resource ID."
  value       = azurerm_databricks_workspace.this.id
}

output "workspace_url" {
  description = "Databricks workspace URL."
  value       = azurerm_databricks_workspace.this.workspace_url
}
