# This section specifies the required Packer plugins needed for the configuration, 
# in this case, the Amazon plugin version 1.0.4 or later.
packer {
    required_plugins {
        amazon = {
            version = ">= 1.0.4"
            source  = "github.com/hashicorp/amazon"
        }
    }
}

# Variable for AMI-Name -> AMI-Name are unique
# This section defines a local variable timestamp using the regex_replace 
# function to replace any occurrences of -, T, Z, or : in the timestamp() value with an empty string.
locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# This section defines the Amazon Elastic Block Store (EBS) source configuration block. 
# It specifies the AMI name, instance type, AWS region, VPC ID, and subnet ID to use for 
# the source instance. It also specifies the source AMI filter to use for selecting the source AMI, 
# as well as the SSH username, keypair name, and private key file to use for SSH connections. 
# Finally, it defines tags to apply to both the source instance and the resulting AMI.

source "amazon-ebs" "us-west-2" {
    ami_name = "${var.ami_prefix}-${local.timestamp}"
    instance_type = "t2.micro"
    region = var.aws_region
    vpc_id = "vpc-0248de2a65cda01dd"
    subnet_id = "subnet-0661ebf2b7f6dad3d"
 
    source_ami_filter {
        filters = {
            name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
            root-device-type = "ebs"
            virtualization-type = "hvm"
        }
        most_recent = true
        owners      = ["099720109477"] # Canonical
    }
    ssh_username = "ubuntu"
    ssh_keypair_name = "rainpole_packer_key_w1"
    ssh_private_key_file = "rainpole_packer_key_w1.pem"
    #ssh_password = "your_ssh_password"

    tags = {
        Name = "rainpole_ami_ssm_image"
    }
    snapshot_tags = {
        Name = "rainpole_ami_ssm_image"
    }
}

# This section specifies the build block for Packer. It specifies the build name, 
# sources, and then adds additional metadata such as build and bucket labels, 
# and a description of the Packer build.

build {
    name = "rainpole"
    sources = [
        "source.amazon-ebs.us-west-2"
    ]

hcp_packer_registry {
    bucket_name = "fake-service"
    description = <<EOT
    This image is a fake-Service app running on ubuntu
        EOT

    bucket_lables = {
        "target-use" = "Rainple_App"
        "service" = "fake-Service"
    }    

    build_labels = {
        "os" = "ubuntu Focal"
        "version" = "20.04"
    }
}
}

# This section defines a Terraform variable named aws_region with a default value of us-west-1.

variable "aws_region" {
  description = "AWS Region Variable"
  type        = string
  default     = "us-west-1"
}

# Required for Packer AMI
variable "ami_prefix" {
    type = string
    default = "fake-service"
}