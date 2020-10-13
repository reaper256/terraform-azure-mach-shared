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

  dynamic "access_policy" {
    for_each = toset(var.certificate_access_object_ids)
    
    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value

      certificate_permissions = [
        "create",
        "delete",
        "deleteissuers",
        "get",
        "getissuers",
        "import",
        "list",
        "listissuers",
        "managecontacts",
        "manageissuers",
        "setissuers",
        "update",
      ]

      key_permissions = [
        "backup",
        "create",
        "decrypt",
        "delete",
        "encrypt",
        "get",
        "import",
        "list",
        "purge",
        "recover",
        "restore",
        "sign",
        "unwrapKey",
        "update",
        "verify",
        "wrapKey",
      ]

      secret_permissions = [
        "backup",
        "delete",
        "get",
        "list",
        "purge",
        "recover",
        "restore",
        "set",
      ]
    }
  }
    
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
}
