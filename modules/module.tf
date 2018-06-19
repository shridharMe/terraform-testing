# Terraform Configuration

terraform {
  # The configuration is restricted to Terraform versions supported by
  # Kitchen-Terraform
  required_version = ">= 0.10.2, < 0.12.0"
}

# Input Variable Configuration

variable "ami_id" {
  description = "The Amazon Machine Image (AMI) to use for the AWS EC2 instances"
  type        = "string"
}

variable "subnet_availability_zone" {
  description = "The isolated, regional location in which to place the subnet"
  type        = "string"
}

# Provider Configuration

provider "aws" {
  version = "~> 0.1"
  region  = "eu-west-2"
}

provider "random" {
  version = "~> 1.0"
}

# Resource Configuration

# These aws_instances will be targeted with the operating_system control and the
# reachable_other_host control

module "ec2" {
  source = "git::https://BITBUCKET_CREDENTIALS@bitbucket.org/DCGOnline/terraform_modules.git//ec2?ref=DHD-49-create-central-repositories-for-m"

  #source               ="git::git@bitbucket.org:DCGOnline/terraform_modules.git//ec2?ref=master"
  key_name             = "${var.key_name}"
  name                 = "ec2-terraform-test"
  environment          = "ec2-test"
  resource_type_tag    = "resource_type_tag"
  subnet_ids           = ["${aws_subnet.extensive_tutorial.id}"]
  vpc_id               = "${aws_vpc.extensive_tutorial.id}"
  security_groups      = ["${aws_security_group.instance-app-sg.id}"]
  ami_id               = "${var.ami_id}"
  type                 = "t2.micro"
  environment          = "environment"
  service_tag          = "service_tag"
  servicecomponent_tag = "servicecomponent_tag"
  networktier_tag      = "networktier_tag"
}

resource "aws_security_group" "extensive_tutorial" {
  description = "Allow all inbound traffic"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["92.236.122.147/32"]
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
  }

  name = "kitchen-terraform-extensive_tutorial"

  tags {
    Name      = "kitchen-terraform-extensive_tutorial"
    Terraform = "true"
  }

  vpc_id = "${aws_vpc.extensive_tutorial.id}"
}

resource "aws_route_table_association" "extensive_tutorial" {
  route_table_id = "${aws_route_table.extensive_tutorial.id}"
  subnet_id      = "${aws_subnet.extensive_tutorial.id}"
}

resource "aws_route_table" "extensive_tutorial" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.extensive_tutorial.id}"
  }

  tags {
    Name = "kitchen_terraform_extensive_tutorial"
  }

  vpc_id = "${aws_vpc.extensive_tutorial.id}"
}

resource "aws_internet_gateway" "extensive_tutorial" {
  tags = {
    Name = "kitchen_terraform_extensive_tutorial"
  }

  vpc_id = "${aws_vpc.extensive_tutorial.id}"
}

resource "aws_subnet" "extensive_tutorial" {
  availability_zone       = "${var.subnet_availability_zone}"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = "true"

  tags {
    Name = "kitchen_terraform_extensive_tutorial"
  }

  vpc_id = "${aws_vpc.extensive_tutorial.id}"
}

resource "aws_vpc" "extensive_tutorial" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = "true"

  tags {
    Name = "kitchen_terraform_extensive_tutorial"
  }
}

# Output Configuration

# This output is used as an attribute in the reachable_other_host control
output "reachable_other_host_id" {
  description = "The ID of the reachable_other_host instance"
  value       = "${aws_instance.reachable_other_host.public_ip}"
}

# This output is used to obtain targets for InSpec
output "remote_group_public_dns" {
  description = "The list of public DNS names of the remote_group instances"
  value       = ["${aws_instance.remote_group.*.public_dns}"]
}
