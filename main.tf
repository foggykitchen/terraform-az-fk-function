locals {
  effective_service_plan_id   = var.create_service_plan ? azurerm_service_plan.this[0].id : var.service_plan_id
  effective_service_plan_name = var.create_service_plan ? azurerm_service_plan.this[0].name : null

  key_vault_app_settings = {
    for name, secret in nonsensitive(var.secrets) :
    name => "@Microsoft.KeyVault(SecretUri=${secret.key_vault_secret_id})"
  }
}

resource "azurerm_service_plan" "this" {
  count = var.create_service_plan ? 1 : 0

  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  tags                = var.tags

  lifecycle {
    precondition {
      condition     = var.service_plan_name != null
      error_message = "service_plan_name is required when create_service_plan is true."
    }
  }
}

resource "azurerm_linux_function_app" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = local.effective_service_plan_id

  storage_account_name          = var.storage_account_name
  storage_account_access_key    = var.storage_account_access_key
  storage_key_vault_secret_id   = var.storage_key_vault_secret_id
  storage_uses_managed_identity = var.storage_uses_managed_identity ? true : null

  app_settings                    = merge(var.app_settings, local.key_vault_app_settings)
  functions_extension_version     = var.functions_extension_version
  key_vault_reference_identity_id = var.key_vault_reference_identity_id
  virtual_network_subnet_id       = var.infrastructure_subnet_id
  public_network_access_enabled   = var.public_network_access_enabled
  https_only                      = var.https_only
  zip_deploy_file                 = var.zip_deploy_file
  tags                            = var.tags

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  site_config {
    application_insights_connection_string = var.application_insights_connection_string
    app_scale_limit                        = var.app_scale_limit
    elastic_instance_minimum               = var.elastic_instance_minimum
    ftps_state                             = "Disabled"
    minimum_tls_version                    = "1.2"
    scm_minimum_tls_version                = "1.2"
    vnet_route_all_enabled                 = var.vnet_route_all_enabled

    dynamic "application_stack" {
      for_each = contains(["dotnet", "dotnet-isolated"], var.runtime_stack.language) ? [var.runtime_stack] : []

      content {
        dotnet_version              = application_stack.value.version
        use_dotnet_isolated_runtime = application_stack.value.language == "dotnet-isolated"
      }
    }

    dynamic "application_stack" {
      for_each = var.runtime_stack.language == "java" ? [var.runtime_stack] : []

      content {
        java_version = application_stack.value.version
      }
    }

    dynamic "application_stack" {
      for_each = var.runtime_stack.language == "node" ? [var.runtime_stack] : []

      content {
        node_version = application_stack.value.version
      }
    }

    dynamic "application_stack" {
      for_each = var.runtime_stack.language == "powershell" ? [var.runtime_stack] : []

      content {
        powershell_core_version = application_stack.value.version
      }
    }

    dynamic "application_stack" {
      for_each = var.runtime_stack.language == "python" ? [var.runtime_stack] : []

      content {
        python_version = application_stack.value.version
      }
    }

    dynamic "application_stack" {
      for_each = var.runtime_stack.language == "custom" ? [var.runtime_stack] : []

      content {
        use_custom_runtime = true
      }
    }
  }

  lifecycle {
    precondition {
      condition     = var.create_service_plan || var.service_plan_id != null
      error_message = "service_plan_id is required when create_service_plan is false."
    }

    precondition {
      condition = length(compact([
        var.storage_account_access_key != null ? "access_key" : "",
        var.storage_key_vault_secret_id != null ? "key_vault" : "",
        var.storage_uses_managed_identity ? "managed_identity" : ""
      ])) == 1
      error_message = "Set exactly one of storage_account_access_key, storage_key_vault_secret_id, or storage_uses_managed_identity."
    }

    precondition {
      condition     = !var.storage_uses_managed_identity || var.identity != null
      error_message = "identity is required when storage_uses_managed_identity is true."
    }
  }
}

resource "azapi_update_resource" "vnet_content_share" {
  count = var.vnet_content_share_enabled ? 1 : 0

  type        = "Microsoft.Web/sites@2024-04-01"
  resource_id = azurerm_linux_function_app.this.id

  body = {
    properties = {
      vnetContentShareEnabled = true
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.log_analytics_workspace_id == null ? 0 : 1

  name                       = "${var.name}-diagnostics"
  target_resource_id         = azurerm_linux_function_app.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "FunctionAppLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
