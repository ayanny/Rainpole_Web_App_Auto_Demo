packer {
    required_plugins {
        amazon = {
            version = ">= 1.0.4"
            source  = "github.com/hashicorp/amazon"
        }
    }
}

# Variable for AMI-Name -> AMI-Name are unique
locals {
    timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "us-west-2" {
    ami_name = "${var.ami_prefix}-${local.timestamp}"
    instance_type = "t2.micro"
    region = var.aws_region
    vpc_id = "vpc-04ce026e7d56b01d3"
    subnet_id = "subnet-00c822310edb721a3"
 
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
    ssh_keypair_name = "rainpole_packer_key"
    ssh_private_key_file = "rainpole_packer_key.pem"
    #ssh_password = "your_ssh_password"

    tags = {
        Name = "rainpole_ami_ssm_image"
    }
    snapshot_tags = {
        Name = "rainpole_ami_ssm_image"
    }
}

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

variable "aws_region" {
  description = "AWS Region Variable"
  type        = string
  default     = "us-west-2"
}

# Required for Packer AMI
variable "ami_prefix" {
    type = string
    default = "fake-service"
}