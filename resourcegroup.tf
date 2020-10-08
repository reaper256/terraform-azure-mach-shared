resource "azurerm_resource_group" "shared" {
  name     = format("%s-rg", var.name_prefix)
  location = local.region_full

  tags     = var.tags
}
