data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/function"
  output_path = "${path.module}/function.zip"
}

module "function" {
  source = "../../"

  name                = "fk-fn-public-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  service_plan_name = "fk-fn-public-plan-${random_string.suffix.result}"
  sku_name          = "Y1"

  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.primary_access_key

  runtime_stack = {
    language = "python"
    version  = "3.12"
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
  zip_deploy_file = data.archive_file.function.output_path
  tags            = var.tags
}
