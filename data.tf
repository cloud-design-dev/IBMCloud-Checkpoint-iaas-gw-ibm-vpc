data "ibm_is_ssh_key" "deploy_key" {
  name = var.ssh_key
}

data "ibm_is_region" "region" {
  name = var.region
}

data "ibm_resource_group" "rg" {
  name = var.resource_group
}

data "ibm_is_zones" "mzr" {
  region = var.region
}
