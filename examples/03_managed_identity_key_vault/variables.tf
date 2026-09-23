variable "resource_group_name" {
  description = "Resource group name."
  type        = string
  default     = "fk-function-identity-rg"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "westeurope"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default = {
    project = "foggykitchen"
    env     = "dev"
  }
}
