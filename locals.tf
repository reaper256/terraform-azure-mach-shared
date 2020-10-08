locals {
  region_display_map_long = {
    "westeurope"  = "West Europe"
    "northeurope" = "North Europe"
  }

  region_display_map_short = {
    "westeurope"  = "we"
    "northeurope" = "ne"
  }

  region_full  = local.region_display_map_long[var.region]
  region_short = local.region_display_map_short[var.region]
}