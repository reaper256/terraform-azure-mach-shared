variable "name_prefix" {
  default = ""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "storage_account_replication_type" {
  default = "ZRS"
}

variable "region" {
  type        = string
  description = "Region: Azure region"

  # validation {
  #   condition     = contains(["westeurope", "northeurope"], var.region)
  #   error_message = "The region value must be one of westeurope, northeurope"
  # }
}

variable "dns_zone_name" {
  type = string
  default = ""
}

variable "certificate_access_object_ids" {
  type = list
  default = []
}