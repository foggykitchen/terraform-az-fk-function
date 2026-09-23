module "storage" {
  source = "github.com/foggykitchen/terraform-az-fk-storage"

  name                = "fkfnpublic${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = var.tags
}
