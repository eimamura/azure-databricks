output "id" {
  description = "AI Foundry hub resource ID."
  value       = azurerm_ai_foundry.this.id
}

output "name" {
  description = "AI Foundry hub name."
  value       = azurerm_ai_foundry.this.name
}

output "principal_id" {
  description = "System-assigned managed identity principal ID."
  value       = azurerm_ai_foundry.this.identity[0].principal_id
}
