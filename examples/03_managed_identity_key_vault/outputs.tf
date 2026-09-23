output "function_app_id" {
  value = module.function.id
}

output "function_app_name" {
  value = module.function.name
}

output "function_identity_id" {
  value = module.identity.id
}

output "function_identity_principal_id" {
  value = module.identity.principal_id
}

output "key_vault_id" {
  value = module.key_vault.key_vault_id
}

output "key_vault_secret_id" {
  value     = azurerm_key_vault_secret.example.versionless_id
  sensitive = true
}
