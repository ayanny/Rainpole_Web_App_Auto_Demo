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
  access_key = data.vault_generic_secret.aws_cred.access_key
  secret_key = data.vault_generic_secret.aws_cred.secret_key
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}

provider "vault" {
#  address   = local.hcp_vault_public_endpoint
  address = "https://Rainpole-Vault-Cluster-public-vault-189353e2.b5e88078.z1.hashicorp.cloud:8200"
  token   = var.vault_token
#  namespace = local.hcp_vault_namespace

}

data "vault_generic_secret" "aws_cred" {
  path = "aws/creds/rainpole-role"
}
