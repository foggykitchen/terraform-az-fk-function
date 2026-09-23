# Azure Functions with Terraform/OpenTofu - Training Examples

This directory contains progressive free examples used with the **terraform-az-fk-function** module.
The examples are designed as incremental building blocks for code-first Azure Functions architectures on Azure.

These examples are part of the [FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/) and are meant to be applied independently for learning and experimentation.

---

## Example Overview

| Example | Title | Key Topics |
|:-------:|:------|:-----------|
| 01 | **Public HTTP Function** | FoggyKitchen Storage, Linux Consumption plan, Python HTTP trigger, ZIP deployment |
| 02 | **Internal VNet Integration** | FoggyKitchen VNet and Storage, delegated subnet, storage network rules, Elastic Premium plan |
| 03 | **Managed Identity and Key Vault** | FoggyKitchen Storage, Managed Identity, RBAC, Key Vault references, secret-free configuration |

---

## How to Use

Each example directory contains:

- Terraform/OpenTofu configuration (`.tf`)
- A focused `README.md` explaining the goal of the example
- A `terraform.tfvars.example` file with non-secret placeholder values
- A small Python HTTP-triggered function under `function/`

To run an example:

```bash
cd examples/01_public_http_function
cp terraform.tfvars.example terraform.tfvars
tofu init
tofu plan
tofu apply
```

The current free learning path contains these focused examples:

```text
01
02
03
```

Each example owns an independent state and can be deployed separately. Larger event-driven compositions belong in FoggyKitchen landing zones or blueprints, not in free module examples.

---

## Design Principles

- One example = one architectural goal
- Function source and trigger bindings live in examples, not in the root infrastructure module
- Storage, networking, identity, RBAC, and Key Vault are composed with dedicated FoggyKitchen modules
- Examples require no secrets in `terraform.tfvars`
- Host Storage is an Azure Functions runtime dependency even when Python code does not access blobs directly
- VNet integration controls outbound connectivity; private inbound access requires a separately composed Private Endpoint
- Event Grid, Service Bus, API Management, and CI/CD remain outside this module

---

## Blueprint Candidates

Advanced Azure Functions scenarios should be modeled as FoggyKitchen landing zones or blueprints:

- Event Grid-triggered ingestion pipelines
- Service Bus-triggered asynchronous processing
- Private Function Apps with Private Endpoint, Private DNS, and centralized egress
- API Management-fronted serverless APIs
- Managed-identity access to databases and other Azure PaaS services

---

## Related Resources

- [FoggyKitchen Azure Function Module](../)
- [FoggyKitchen Azure Storage Module](https://github.com/foggykitchen/terraform-az-fk-storage)
- [FoggyKitchen Azure VNet Module](https://github.com/foggykitchen/terraform-az-fk-vnet)
- [FoggyKitchen Azure Managed Identity Module](https://github.com/foggykitchen/terraform-az-fk-managed-identity)
- [FoggyKitchen Azure RBAC Module](https://github.com/foggykitchen/terraform-az-fk-rbac)
- [FoggyKitchen Azure Key Vault Module](https://github.com/foggykitchen/terraform-az-fk-key-vault)

---

## License

Licensed under the Universal Permissive License (UPL), Version 1.0.
See [LICENSE](../LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
