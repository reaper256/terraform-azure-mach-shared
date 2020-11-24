# Azure Shared Infra module

To provision a 'shared' resource group in Azure.

## Usage

```
module "shared_infra" {
  source                       = "git::https://github.com/labd/terraform-azure-mach-shared.git"
  name_prefix                  = "mach-we"
  region                       = "westeurope"
}
```
