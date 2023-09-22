locals {
  components_sa_name = replace(
    lower(format("%s-sa-components", var.name_prefix)),
    "-",
    ""
  )
  terra_sa_name = replace(
    lower(format("%s-sa-terra", var.name_prefix)),
    "-",
    ""
  )
}

resource "azurerm_storage_account" "components" {
  name                     = local.components_sa_name
  resource_group_name      = azurerm_resource_group.shared.name
  location                 = azurerm_resource_group.shared.location
  account_kind             = "BlockBlobStorage"
  account_tier             = "Premium"
  account_replication_type = var.storage_account_replication_type
  allow_nested_items_to_be_public = true
  tags = var.tags
}

resource "azurerm_storage_container" "code" {
  name                  = "code"
  storage_account_name  = azurerm_storage_account.components.name
  container_access_type = "private"
}


resource "azurerm_storage_account" "terraform" {
  name                     = local.terra_sa_name
  resource_group_name      = azurerm_resource_group.shared.name
  location                 = azurerm_resource_group.shared.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "RAGZRS"
  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform.name
  container_access_type = "private"
}


