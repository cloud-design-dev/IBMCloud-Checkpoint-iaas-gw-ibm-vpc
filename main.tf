module vpc {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Module.git"
  name           = var.vpc_name
  resource_group = data.ibm_resource_group.rg.id
  tags           = ["project:${var.vpc_name}", "region:${var.region}"]
}

module public_gateway {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Public-Gateway-Module.git"
  name           = var.vpc_name
  zone           = data.ibm_is_zones.mzr.zones[0]
  vpc            = module.vpc.id
  resource_group = data.ibm_resource_group.rg.id
  tags           = concat(var.tags, ["project:${var.vpc_name}", "region:${var.region}"])
}

module management_subnet {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.vpc_name}-mgmt-subnet"
  zone           = data.ibm_is_zones.mzr.zones[0]
  vpc            = module.vpc.id
  address_count  = "32"
  resource_group = data.ibm_resource_group.rg.id
  public_gateway = module.public_gateway.id
}

module external_subnet {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.vpc_name}-external-subnet"
  zone           = data.ibm_is_zones.mzr.zones[0]
  vpc            = module.vpc.id
  address_count  = "32"
  resource_group = data.ibm_resource_group.rg.id
  public_gateway = module.public_gateway.id
}

module internal_subnet {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.vpc_name}-internal-subnet"
  zone           = data.ibm_is_zones.mzr.zones[0]
  vpc            = module.vpc.id
  address_count  = "32"
  resource_group = data.ibm_resource_group.rg.id
  public_gateway = module.public_gateway.id
}

module application_subnet {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.vpc_name}-app-subnet"
  zone           = data.ibm_is_zones.mzr.zones[0]
  vpc            = module.vpc.id
  address_count  = "32"
  resource_group = data.ibm_resource_group.rg.id
  public_gateway = module.public_gateway.id
}

module database_subnet {
  source         = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Subnet-Module.git"
  name           = "${var.vpc_name}-db-subnet"
  zone           = data.ibm_is_zones.mzr.zones[0]
  vpc            = module.vpc.id
  address_count  = "32"
  resource_group = data.ibm_resource_group.rg.id
  public_gateway = module.public_gateway.id
}

module checkpoint {
  depends_on           = [module.vpc]
  source               = "git::https://github.com/cloud-design-dev/checkpoint-iaas-gw-ibm-vpc.git"
  VPC_Region           = var.region
  VPC_Name             = var.vpc_name
  Management_Subnet_ID = module.management_subnet.id
  External_Subnet_ID   = module.external_subnet.id
  Internal_Subnet_ID   = module.internal_subnet.id
  SSH_Key              = var.ssh_key
  VNF_Security_Group   = "${var.vpc_name}-chkpnt-sg"
  ibmcloud_api_key     = var.ibmcloud_api_key
  Resource_Group       = var.resource_group
}

module app_server {
  source            = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Instance-Module.git"
  vpc_id            = module.vpc.id
  zone              = data.ibm_is_zones.mzr.zones[0]
  ssh_keys          = [data.ibm_is_ssh_key.deploy_key.id]
  subnet_id         = module.application_subnet.id
  resource_group    = data.ibm_resource_group.rg.id
  name              = "${var.vpc_name}-app-server"
  security_group_id = module.vpc.default_security_group
  tags              = concat(var.tags, ["project:${var.vpc_name}", "region:${var.region}"])
  user_data         = file("${path.module}/init.yml")
}

module db_server {
  source            = "git::https://github.com/cloud-design-dev/IBM-Cloud-VPC-Instance-Module.git"
  vpc_id            = module.vpc.id
  zone              = data.ibm_is_zones.mzr.zones[0]
  ssh_keys          = [data.ibm_is_ssh_key.deploy_key.id]
  subnet_id         = module.database_subnet.id
  resource_group    = data.ibm_resource_group.rg.id
  name              = "${var.vpc_name}-db-server"
  security_group_id = module.vpc.default_security_group
  tags              = concat(var.tags, ["project:${var.vpc_name}", "region:${var.region}"])
  user_data         = file("${path.module}/init.yml")
}

resource "ibm_is_floating_ip" "checkpoint_ui" {
  depends_on     = [module.checkpoint]
  resource_group = data.ibm_resource_group.rg.id
  name           = "${var.vpc_name}-chkpnt-ui"
  target         = module.checkpoint.checkpoint_primary_interface
}