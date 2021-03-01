# Azure Shared Infra module

To provision a 'shared' resource group in Azure.

[More information](https://docs.machcomposer.io/tutorial/azure/step-3-setup-azure.html) on how to setup your Azure environment for MACH.

### Resources created

- 'shared' resource group
- storage account for Terraform state files
- storage account for Components

When `dns_zone_name` is given:

- DNS zone
- Domain certificates + KeyVault to store them

## Usage

```
module "shared_infra" {
  source                       = "git::https://github.com/labd/terraform-azure-mach-shared.git"
  name_prefix                  = "mach-we"
  region                       = "westeurope"
  dns_zone_name                = your-projects-services.net
}
```

### Variables

| name                               | required | description                                                                 |
| ---------------------------------- | -------- | --------------------------------------------------------------------------- |
| `region`                           | *        | Which region to create the shared resources in                              |
| `name_prefix`                      |          | Prefix to be used when naming resources                                     |
| `tags`                             |          | Tags to apply to the shared resources                                       |
| `storage_account_replication_type` |          | Replication type of the 'components' storage account                        |
| `dns_zone_name`                    |          | The custom DNS zone to create                                               |
| `certificate_access_object_ids`    |          | Object IDs of all users/groups to should be able to access the certificates |
