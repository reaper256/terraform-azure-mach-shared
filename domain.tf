locals {
  dns_zone_names = var.dns_zone_name == "" ? toset([]) : toset([
    var.dns_zone_name
  ])
}

data "azurerm_client_config" "current" {
}

resource "azurerm_dns_zone" "dns_zone" {
  for_each            = local.dns_zone_names
  name                = each.value
  resource_group_name = azurerm_resource_group.shared.name
}


resource "azurerm_key_vault" "certificates" {
  name                        = replace(format("%s-kv-certs", var.name_prefix), "-", "")
  location                    = azurerm_resource_group.shared.location
  resource_group_name         = azurerm_resource_group.shared.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption = true
  sku_name                    = "standard"
}

resource "azurerm_key_vault_access_policy" "frontdoor_access" {
  key_vault_id = azurerm_key_vault.certificates.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id = "ad0e1c7e-6d38-4ba4-9efd-0bc77ba9f037" # Microsoft.Azure.Frontdoor

  certificate_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
}

resource "azurerm_key_vault_access_policy" "cdn_access" {
  key_vault_id = azurerm_key_vault.certificates.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id    = "205478c0-bd83-4e1b-a9d6-db63a3e1e1c8" # Microsoft.Azure.Cdn

  certificate_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
}

resource "azurerm_key_vault_access_policy" "manage_access" {
  for_each = toset(var.certificate_access_object_ids)
  
  key_vault_id = azurerm_key_vault.certificates.id
  
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = each.value

  certificate_permissions = [
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "SetIssuers",
    "Update",
  ]

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "List",
  ]

  secret_permissions = [
    "Delete",
    "Get",
    "List",
    "Set",
  ]
}

resource "azurerm_key_vault_certificate" "cert" {
  for_each     = local.dns_zone_names

  name         = replace(each.value, ".", "-")
  key_vault_id = azurerm_key_vault.certificates.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["*.${each.value}", each.value]
      }

      subject            = "CN=${each.value}"
      validity_in_months = 12
    }
  }

  depends_on = [
    azurerm_key_vault_access_policy.manage_access
  ]
}
