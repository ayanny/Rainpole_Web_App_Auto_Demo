terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.37.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.3"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">=2.2.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.11.0"
    }    
  }
}

provider "aws" {
  # access_key = data.vault_aws_access_credentials.creds.access_key
  # secret_key = data.vault_aws_access_credentials.creds.secret_key
  region     = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}

provider "hcp" {
}

