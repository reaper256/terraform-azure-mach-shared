# Azure Shared Infra module

To provision a 'shared' resource group in Azure.

This resource group should already be created (manually) because a Terraform state backend should already be present.

## Usage

```
module "shared_infra" {
  source                       = "git::https://git.labdigital.nl/mach/terraform/terraform-azure-shared-infra.git"
  name_prefix                  = "mach"
  shared_resource_group        = "mach-shared-rg"
}
```