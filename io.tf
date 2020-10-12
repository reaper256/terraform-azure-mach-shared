output "dns_zone_name" {
  value = azurerm_dns_zone.mars_labdio.name
}

output "resource_group_name" {
  value = azurerm_resource_group.shared.name
}