# Azure Shared Infra module

To provision a 'shared' resource group in Azure.

This resource group should already be created (manually) because a Terraform state backend should already be present.

## Usage

```
module "shared_infra" {
  source                       = "git::https://github.com/labd/terraform-azure-mach-shared.git"
  name_prefix                  = "mach-we"
  region                       = "westeurope"
}
```