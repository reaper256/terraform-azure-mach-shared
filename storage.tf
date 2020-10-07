locals {
  storage_account_name = replace(
    lower(format("%s-sa-components", var.name_prefix)),
    "-",
    ""
  )
}

resource "azurerm_storage_account" "components" {
  name                     = local.storage_account_name
  resource_group_name      = data.azurerm_resource_group.shared.name
  location                 = data.azurerm_resource_group.shared.location
  account_kind             = "BlockBlobStorage"
  account_tier             = "Premium"
  account_replication_type = var.storage_account_replication_type
  allow_blob_public_access = true
  tags = var.tags
}

resource "azurerm_storage_container" "code" {
  name                  = "code"
  storage_account_name  = azurerm_storage_account.components.name
  container_access_type = "blob"
}
