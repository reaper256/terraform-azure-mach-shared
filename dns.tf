resource "azurerm_dns_zone" "mars_labdio" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.shared.name
}