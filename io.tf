output "resource_group_name" {
  value = azurerm_resource_group.shared.name
}

output "ssl_key_vault_name" {
  value = var.dns_zone_name != "" ? azurerm_key_vault.certificates[var.dns_zone_name].name : ""
}

output "ssl_key_vault_secret_name" {
  value = var.dns_zone_name != "" ? azurerm_key_vault_certificate.cert[var.dns_zone_name].name : ""
}

output "ssl_key_vault_secret_version" {
  value = var.dns_zone_name != "" ? azurerm_key_vault_certificate.cert[var.dns_zone_name].version : ""
}