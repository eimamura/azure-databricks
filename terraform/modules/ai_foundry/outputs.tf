output "id" {
  description = "AI Foundry account resource ID."
  value       = azurerm_cognitive_account.foundry.id
}

output "name" {
  description = "AI Foundry account name (includes random suffix)."
  value       = azurerm_cognitive_account.foundry.name
}

output "principal_id" {
  description = "System-assigned managed identity principal ID."
  value       = azurerm_cognitive_account.foundry.identity[0].principal_id
}

output "endpoint" {
  description = "AI Foundry API endpoint."
  value       = azurerm_cognitive_account.foundry.endpoint
}

output "project_id" {
  description = "AI Foundry project resource ID."
  value       = azurerm_cognitive_account_project.project.id
}
