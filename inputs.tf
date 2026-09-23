variable "name" {
  description = "Linux Function App name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "create_service_plan" {
  description = "Whether the module creates a Linux Service Plan."
  type        = bool
  default     = true
}

variable "service_plan_name" {
  description = "Service Plan name. Required when create_service_plan is true."
  type        = string
  default     = null
}

variable "service_plan_id" {
  description = "Existing Service Plan resource ID. Required when create_service_plan is false."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "Linux Functions Service Plan SKU: Y1 Consumption or EP1, EP2, EP3 Elastic Premium."
  type        = string
  default     = "Y1"

  validation {
    condition     = contains(["Y1", "EP1", "EP2", "EP3"], var.sku_name)
    error_message = "sku_name must be Y1, EP1, EP2, or EP3. Flex Consumption uses a different AzureRM resource and is not supported by this module."
  }
}

variable "storage_account_name" {
  description = "Existing Storage Account name used by the Functions host."
  type        = string
}

variable "storage_account_access_key" {
  description = "Storage Account access key. Set exactly one storage authentication mechanism."
  type        = string
  default     = null
  sensitive   = true
}

variable "storage_key_vault_secret_id" {
  description = "Versioned Key Vault secret ID containing the Functions storage connection string. Set exactly one storage authentication mechanism."
  type        = string
  default     = null
}

variable "storage_uses_managed_identity" {
  description = "Whether the Function App managed identity authenticates to host storage. Set exactly one storage authentication mechanism."
  type        = bool
  default     = false
}

variable "infrastructure_subnet_id" {
  description = "Subnet ID used for regional VNet integration. This controls outbound integration, not inbound Private Endpoint access."
  type        = string
  default     = null
}

variable "identity" {
  description = "Optional managed identity assigned to the Function App."
  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null

  validation {
    condition     = var.identity == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type)
    error_message = "identity.type must be SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
  }
}

variable "key_vault_reference_identity_id" {
  description = "User-assigned identity resource ID used to resolve Key Vault references."
  type        = string
  default     = null
}

variable "secrets" {
  description = "App settings rendered as Key Vault references, keyed by app setting name."
  type = map(object({
    key_vault_secret_id = string
  }))
  default   = {}
  sensitive = true
}

variable "app_settings" {
  description = "Function App settings. Do not place plaintext secrets here; use secrets instead."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "runtime_stack" {
  description = "Linux Functions language and provider-supported runtime version."
  type = object({
    language = string
    version  = string
  })
  default = {
    language = "python"
    version  = "3.12"
  }

  validation {
    condition = (
      var.runtime_stack.language == "dotnet" && contains(["3.1", "6.0", "7.0", "8.0", "9.0"], var.runtime_stack.version)
      || var.runtime_stack.language == "dotnet-isolated" && contains(["3.1", "6.0", "7.0", "8.0", "9.0"], var.runtime_stack.version)
      || var.runtime_stack.language == "java" && contains(["8", "11", "17", "21", "25"], var.runtime_stack.version)
      || var.runtime_stack.language == "node" && contains(["12", "14", "16", "18", "20", "22", "24"], var.runtime_stack.version)
      || var.runtime_stack.language == "powershell" && contains(["7", "7.2", "7.4"], var.runtime_stack.version)
      || var.runtime_stack.language == "python" && contains(["3.7", "3.8", "3.9", "3.10", "3.11", "3.12", "3.13", "3.14"], var.runtime_stack.version)
      || var.runtime_stack.language == "custom" && var.runtime_stack.version == "custom"
    )
    error_message = "runtime_stack must use a language/version combination supported by azurerm_linux_function_app in AzureRM 4.x."
  }
}

variable "functions_extension_version" {
  description = "Azure Functions host extension version."
  type        = string
  default     = "~4"
}

variable "application_insights_connection_string" {
  description = "Existing Application Insights connection string for native Functions telemetry."
  type        = string
  default     = null
  sensitive   = true
}

variable "log_analytics_workspace_id" {
  description = "Existing Log Analytics Workspace ID for platform diagnostic logs."
  type        = string
  default     = null
}

variable "zip_deploy_file" {
  description = "Optional local ZIP package path deployed by AzureRM."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether the Function App public endpoint is enabled."
  type        = bool
  default     = true
}

variable "https_only" {
  description = "Whether HTTPS is required."
  type        = bool
  default     = true
}

variable "vnet_route_all_enabled" {
  description = "Whether all outbound traffic is routed through the integrated VNet."
  type        = bool
  default     = false
}

variable "vnet_content_share_enabled" {
  description = "Whether Azure Files content-share traffic is routed through the integrated VNet. Enable for network-restricted host storage."
  type        = bool
  default     = false
}

variable "app_scale_limit" {
  description = "Optional maximum scale-out worker count for Consumption and Premium plans."
  type        = number
  default     = null
}

variable "elastic_instance_minimum" {
  description = "Optional minimum instance count for Elastic Premium plans."
  type        = number
  default     = null
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
