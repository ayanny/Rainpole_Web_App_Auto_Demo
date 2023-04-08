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
  access_key = data.vault_aws_access_credentials.creds.access_key
  secret_key = data.vault_aws_access_credentials.creds.secret_key
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}


provider "vault" {
#  address   = local.hcp_vault_public_endpoint
#  version = ">= 2.1.0"
  address = "https://rainpole-vault-cluster-public-vault-189353e2.b5e88078.z1.hashicorp.cloud:8200/ui/vault/secrets?namespace=admin"
  token   = var.vault_token
}

# data "vault_aws_access_credentials" "aws" {
#   path = "aws/creds/my-role"
# }




resource "vault_aws_secret_backend" "aws" {
  access_key = var.vault_access_key
  secret_key = var.vault_secret_key
}

resource "vault_aws_secret_backend_role" "role" {
  backend = vault_aws_secret_backend.aws.path
  credential_type = "iam_user"
  name    = "my-role2"

#   policy = <<EOT
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "iam:*",
#       "Resource": "*"
#     }
#   ]
# }
# EOT
}

# generally, these blocks would be in a different module
data "vault_aws_access_credentials" "creds" {
  backend = vault_aws_secret_backend.aws.path
  role    = vault_aws_secret_backend_role.role.name
}
