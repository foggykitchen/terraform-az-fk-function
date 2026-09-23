# terraform-az-fk-function

This repository contains a reusable Terraform / OpenTofu module and progressive examples for deploying code-first, ZIP-deployed Azure Linux Function Apps.

It is part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/) and composes with FoggyKitchen modules for Storage, VNet, Managed Identity, RBAC, Key Vault, Log Analytics, and related Azure foundations.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## Purpose

The module provides the Azure Functions runtime foundation needed by future event-driven modules and blueprints:

- Linux Function App and Service Plan lifecycle
- Code-first runtime stack configuration and optional ZIP deployment
- Existing Storage Account composition with access-key, Key Vault, or managed-identity authentication
- Optional VNet, observability, managed identity, and Key Vault-reference integration

This is not a container-image runtime. Container workloads belong in `terraform-az-fk-container-apps`. Event sources and trigger bindings remain separate composition concerns.

---

## What the module does

The module creates:

- Azure Linux Function App (`azurerm_linux_function_app`)
- Azure Linux Service Plan unless `create_service_plan = false`
- Optional Azure Monitor diagnostic setting for an existing Log Analytics Workspace
- Optional VNet integration through `infrastructure_subnet_id`
- Optional managed identity and Key Vault-referenced app settings
- Optional ZIP package deployment supplied by the caller

The module intentionally does not create:

- Storage Accounts
- VNets, subnets, or Private Endpoints
- Event Grid, Service Bus, or event-source/trigger-wiring resources
- API Management or other API-gateway-fronting resources
- CI/CD build or deployment pipelines
- Application Insights or Log Analytics Workspace resources
- Function source code or native trigger bindings
- Container-image-based Function Apps

Each of those concerns belongs in its own dedicated module, example, or delivery workflow.

---

## Provider Notes

The contract was verified against AzureRM `4.81.0`, the current version selected by the FoggyKitchen constraint `>= 3.100.0, < 5.0.0` on 2026-09-23.

`azurerm_linux_function_app` uses an App Service Plan. This module supports Linux Consumption (`Y1`, the default) and Elastic Premium (`EP1`, `EP2`, `EP3`). Azure Flex Consumption is represented by the distinct `azurerm_function_app_flex_consumption` resource, not by `azurerm_linux_function_app` plus `azurerm_service_plan`; accepting `FC1` here would therefore be incorrect. Flex support can be added separately when the module intentionally adopts that resource lifecycle.

The Function App schema accepts an Application Insights connection string for native Functions telemetry. A Log Analytics Workspace ID is used by the optional diagnostic setting; it cannot replace the Application Insights connection string.

`infrastructure_subnet_id` configures outbound regional VNet integration. Private inbound access requires a separately composed Private Endpoint and Private DNS configuration.

---

## Repository Structure

```bash
terraform-az-fk-function/
├── examples/
│   ├── 01_public_http_function/
│   ├── 02_internal_vnet_integration/
│   ├── 03_managed_identity_key_vault/
│   └── README.md
├── main.tf
├── inputs.tf
├── outputs.tf
├── versions.tf
├── SUPPORT.md
├── LICENSE
└── README.md
```

---

## Example Usage

```hcl
module "function" {
  source = "git::https://github.com/foggykitchen/terraform-az-fk-function.git?ref=v0.1.0"

  name                = "fk-function-demo"
  resource_group_name = "fk-functions-rg"
  location            = "westeurope"
  service_plan_name   = "fk-function-demo-plan"

  storage_account_name       = module.storage.storage_account_name
  storage_account_access_key = module.storage.primary_access_key

  runtime_stack = {
    language = "python"
    version  = "3.12"
  }
}
```

---

## Module Inputs

| Variable | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | `string` | yes | Linux Function App name |
| `resource_group_name` | `string` | yes | Resource group name |
| `location` | `string` | yes | Azure region |
| `create_service_plan` | `bool` | no | Whether to create a Linux Service Plan |
| `service_plan_name` | `string` | when creating | New Service Plan name |
| `service_plan_id` | `string` | when attaching | Existing Service Plan resource ID |
| `sku_name` | `string` | no | `Y1`, `EP1`, `EP2`, or `EP3` |
| `storage_account_name` | `string` | yes | Existing Functions host Storage Account name |
| `storage_account_access_key` | `string` | one storage auth method | Storage access key |
| `storage_key_vault_secret_id` | `string` | one storage auth method | Versioned secret ID containing the storage connection string |
| `storage_uses_managed_identity` | `bool` | one storage auth method | Use Function App identity for host storage |
| `infrastructure_subnet_id` | `string` | no | Regional VNet integration subnet ID |
| `identity` | `object` | no | Managed identity block |
| `key_vault_reference_identity_id` | `string` | no | User-assigned identity used for Key Vault references |
| `secrets` | `map(object)` | no | Key Vault-referenced app settings |
| `app_settings` | `map(string)` | no | Non-secret Function App settings |
| `runtime_stack` | `object` | no | Runtime language and version |
| `functions_extension_version` | `string` | no | Functions host extension version |
| `application_insights_connection_string` | `string` | no | Existing Application Insights connection string |
| `log_analytics_workspace_id` | `string` | no | Existing workspace ID for platform diagnostics |
| `zip_deploy_file` | `string` | no | Local ZIP package path |
| `public_network_access_enabled` | `bool` | no | Whether the public endpoint is enabled |
| `https_only` | `bool` | no | Whether HTTPS is required |
| `vnet_route_all_enabled` | `bool` | no | Route all outbound traffic through the VNet |
| `vnet_content_share_enabled` | `bool` | no | Route the Azure Files content share through the integrated VNet |
| `app_scale_limit` | `number` | no | Optional Consumption/Premium scale limit |
| `elastic_instance_minimum` | `number` | no | Optional Elastic Premium minimum instances |
| `tags` | `map(string)` | no | Common tags |

---

## Module Outputs

| Output | Description |
|--------|-------------|
| `id` | Linux Function App resource ID |
| `name` | Linux Function App name |
| `service_plan_id` | Effective Service Plan resource ID |
| `service_plan_name` | Created Service Plan name, or null when attaching |
| `default_hostname` | Default Function App hostname |
| `principal_id` | System-assigned identity principal ID, when present |
| `identity` | Function App identity attributes |
| `outbound_ip_address_list` | Current outbound IP addresses |
| `possible_outbound_ip_address_list` | Possible outbound IP addresses |

---

## Examples

See [examples/README.md](examples/README.md) for the progressive lab sequence.

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
