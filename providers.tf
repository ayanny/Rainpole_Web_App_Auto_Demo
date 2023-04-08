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
  }
}

provider "aws" {
  access_key = data.vault_aws_secret.aws.access_key
  secret_key = data.vault_aws_secret.aws.secret_key
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}


provider "vault" {
#  address   = local.hcp_vault_public_endpoint
  version = ">= 2.1.0"
  address = "https://rainpole-vault-cluster-public-vault-189353e2.b5e88078.z1.hashicorp.cloud:8200/ui/vault/secrets?namespace=admin"
  token   = var.vault_token
}

data "vault_aws_secret" "aws" {
  path = "aws/creds/my-role"
}

