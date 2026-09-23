output "id" {
  description = "Linux Function App resource ID."
  value       = azurerm_linux_function_app.this.id
}

output "name" {
  description = "Linux Function App name."
  value       = azurerm_linux_function_app.this.name
}

output "service_plan_id" {
  description = "Effective Service Plan resource ID."
  value       = local.effective_service_plan_id
}

output "service_plan_name" {
  description = "Created Service Plan name, or null when attaching to an existing plan."
  value       = local.effective_service_plan_name
}

output "default_hostname" {
  description = "Default Function App hostname."
  value       = azurerm_linux_function_app.this.default_hostname
}

output "principal_id" {
  description = "System-assigned identity principal ID, when present."
  value       = try(azurerm_linux_function_app.this.identity[0].principal_id, null)
}

output "identity" {
  description = "Function App managed identity attributes."
  value       = azurerm_linux_function_app.this.identity
}

output "outbound_ip_address_list" {
  description = "Current outbound IP addresses."
  value       = azurerm_linux_function_app.this.outbound_ip_address_list
}

output "possible_outbound_ip_address_list" {
  description = "Possible outbound IP addresses."
  value       = azurerm_linux_function_app.this.possible_outbound_ip_address_list
}
