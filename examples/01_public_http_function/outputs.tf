output "function_app_id" {
  value = module.function.id
}

output "function_app_name" {
  value = module.function.name
}

output "function_url" {
  value = "https://${module.function.default_hostname}/api/hello"
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}
