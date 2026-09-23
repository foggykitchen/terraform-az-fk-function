variable "resource_group_name" {
  description = "Resource group name."
  type        = string
  default     = "fk-function-vnet-rg"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "westeurope"
}

variable "my_public_ip" {
  description = "Public IPv4 address of the operator workstation allowed through the Storage Account firewall during deployment."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    project = "foggykitchen"
    env     = "dev"
  }
}
