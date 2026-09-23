module "storage" {
  source = "github.com/foggykitchen/terraform-az-fk-storage"

  name                = "fkfnvnet${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  create_file_shares = true
  file_shares = {
    "fkfncontent${random_string.suffix.result}" = {
      quota_gb = 1
    }
  }

  tags = var.tags
}

resource "azurerm_storage_account_network_rules" "function_host" {
  storage_account_id = module.storage.storage_account_id

  default_action             = "Deny"
  bypass                     = ["AzureServices"]
  ip_rules                   = [var.my_public_ip]
  virtual_network_subnet_ids = [module.vnet.subnet_ids["functions"]]

  depends_on = [module.function]
}
