data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/function.zip"
}

module "function" {
  source = "../../"

  depends_on = [module.storage]

  name                = "fk-fn-vnet-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  service_plan_name = "fk-fn-vnet-plan-${random_string.suffix.result}"
  sku_name          = "EP1"

  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.primary_access_key
  infrastructure_subnet_id   = module.vnet.subnet_ids["functions"]
  vnet_route_all_enabled     = true
  vnet_content_share_enabled = true

  runtime_stack = {
    language = "python"
    version  = "3.12"
  }

  app_settings = {
    WEBSITE_CONTENTOVERVNET  = "1"
    WEBSITE_CONTENTSHARE     = "fkfncontent${random_string.suffix.result}"
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
  zip_deploy_file = data.archive_file.function.output_path
  tags            = var.tags
}
