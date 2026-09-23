module "key_vault" {
  source = "github.com/foggykitchen/terraform-az-fk-key-vault"

  key_vault_name             = "fk-fn-kv-${random_string.suffix.result}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  rbac_authorization_enabled = true
  tags                       = var.tags
}

module "function_key_vault_rbac" {
  source = "github.com/foggykitchen/terraform-az-fk-rbac"

  scope                = module.key_vault.key_vault_id
  principal_id         = module.identity.principal_id
  role_definition_name = "Key Vault Secrets User"
}

module "deployer_key_vault_rbac" {
  source = "github.com/foggykitchen/terraform-az-fk-rbac"

  scope                = module.key_vault.key_vault_id
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-api-key"
  value        = random_password.example_secret.result
  key_vault_id = module.key_vault.key_vault_id

  depends_on = [module.deployer_key_vault_rbac]
}
