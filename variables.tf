variable "name_prefix" {
  default = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "shared_resource_group" {}

variable "storage_account_replication_type" {
  default = "ZRS"
}