## About
This template will deploy a new Check Point security gateway into a new VPC environment. It uses a [forked version](https://github.com/cloud-design-dev/checkpoint-iaas-gw-ibm-vpc) of the official [Checkpoint VPC Template](https://github.com/joe-at-cp/checkpoint-iaas-gw-ibm-vpc) that has been updated to work with our newly deployed VPC.

## Resources 
The deployment will create the following resources:

 - VPC 
 - 5 Subnets [Management, External, Internal, Application, Database]
 - Public Gateway
 - Check Point security gateway
 - An application and database server 

## Check Point Resources
- Check Point knowledgebase article for IBM Cloud VPC deployments [SK170400](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk170400&partition=Basic&product=Security).
- Check Point [Full Deployment Guide](https://supportcenter.checkpoint.com/supportcenter/portal?action=portlets.DCFileAction&eventSubmit_doGetdcdetails=&fileid=112069)

## Deploy all resources

1. Copy `terraform.tfvars.example` to `terraform.tfvars`:
   ```sh
   cp terraform.tfvars.example terraform.tfvars
   ```
1. Edit `terraform.tfvars` to match your environment.

   | Name | Description | Required |
   | ---- | ----------- | ---|
   | ibmcloud_api_key | IBM Cloud API Key | Y |
   | vpc_name | Name of the VPC to create | Y |
   | ssh_key | Name of an existing SSH key to inject in to the VPC instances. command: ```ibmcloud is keys``` | Y |
   | region | Region where the VPC Resources will be deployed. command: ```ibmcloud is regions``` | Y | 
   | resource_group | The resource group that will be used when provisioning resources. command: ```ibmcloud resource groups``` | Y |  
1. Plan deployment:
   ```sh
   terraform init
   terraform plan -out default.tfplan
   ```
1. Apply deployment:
   ```sh
   terraform apply default.tfplan
   ```