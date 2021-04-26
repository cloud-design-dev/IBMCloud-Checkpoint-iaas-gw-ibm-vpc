variable "region" {
  default     = ""
  description = "The region where the VPC, networks, and Check Point instance will be provisioned."
}

variable "resource_group" {
  default     = ""
  description = "The resource group that will be used when provisioning resources. If left unspecififed, the account's default resource group will be used."
}

variable "vpc_name" {
  default     = ""
  description = "Name of the VPC that will be provisioned."
}

variable "ssh_key" {
  default     = ""
  description = "The pubic SSH Key that will be used when provisioning the Check Point Instance."
}

variable "tags" {
  default = []
}

variable "ibmcloud_api_key" {
  default     = ""
  description = "IBM Cloud API key to create resources"
}