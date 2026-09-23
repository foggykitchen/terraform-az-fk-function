module "vnet" {
  source = "github.com/foggykitchen/terraform-az-fk-vnet"

  name                = "fk-fn-vnet-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.42.0.0/16"]

  subnets = {
    functions = {
      address_prefixes  = ["10.42.0.0/24"]
      service_endpoints = ["Microsoft.Storage"]
      delegations = [{
        name = "function-app-integration"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }]
    }
  }

  tags = var.tags
}
