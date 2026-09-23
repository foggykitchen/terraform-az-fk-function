output "function_app_id" {
  value = module.function.id
}

output "function_app_name" {
  value = module.function.name
}

output "function_app_hostname" {
  value = module.function.default_hostname
}

output "functions_subnet_id" {
  value = module.vnet.subnet_ids["functions"]
}
