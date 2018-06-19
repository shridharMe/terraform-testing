# Terraform Configuration

terraform {
  # The configuration is restricted to Terraform versions supported by
  # Kitchen-Terraform
  required_version = ">= 0.10.2, < 0.12.0"
}

# Provider Configuration

provider "aws" {
  version = "~> 0.1"
  region  = "eu-west-2"
}

# Input Variable Configuration
variable "instances_ami" {
  description = <<EOD
The Amazon Machine Image (AMI) to use for the AWS EC2 instances of the module
EOD

  type = "string"
}

variable "instances_ami_operating_system_name" {
  description = "The name of the operating system within the AMI"
  type        = "string"
}

variable "subnet_availability_zone" {
  description = <<EOD
The isolated, regional location in which to place the subnet of the module
EOD

  type = "string"
}

# Module Configuration

module "ec2" {
  source               = "git::https://zarif.samar@accenture.com:Atlassian@=-098@bitbucket.org/DCGOnline/terraform_modules.git//ec2?ref=DHD-49-create-central-repositories-for-m"
  key_name             = "terraform-test"
  name                 = "ec2-tf-test"
  environment          = "ec2-test"
  resource_type_tag    = "resource_type_tag"
  subnet_ids           = ["subnet-0d5a9777"]
  vpc_id               = "vpc-431eaa2b"
  security_groups      = ["sg-8a5134e1"]
  ami_id               = "ami-ee6a718a"
  type                 = "t2.micro"
  environment          = "environment"
  service_tag          = "service_tag"
  servicecomponent_tag = "servicecomponent_tag"
  networktier_tag      = "networktier_tag"
  route53_zone_id      = "ZB77TXI17OMME"
}

# Output Configuration

# This output is used as an attribute in the operating_system control
output "instances_ami_operating_system_name" {
  description = "The name of the operating system within the AMI"

  value = "${var.instances_ami_operating_system_name}"
}

# This output is used as an attribute in the reachable_other_host control

# This output is used as an attribute in the inspec_attributes control
output "static_terraform_output" {
  description = "A static value"
  value       = "static terraform output"
}

# This output is used as an attribute in the state_file control
output "terraform_state" {
  description = "The path to the Terraform state file"

  value = <<EOV
${path.cwd}/terraform.tfstate.d/${terraform.workspace}/terraform.tfstate
EOV
}

# This output is used to obtain targets for InSpec
output "reachable_other_host_id" {
  description = "The ID of the reachable_other_host instance"

  value = "${module.ec2.ec2_public_ip}"
}

# This output is used to obtain targets for InSpec
output "remote_group_public_dns" {
  description = "The list of public DNS names of the remote_group instances"

  value = "${module.ec2.ec2_instance_cname}"
}
