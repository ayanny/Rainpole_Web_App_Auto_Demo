
# Variable for Region, this value will be configured in Terraform Cloud in advance
variable "aws_region" {
  description = "AWS Region Variable"
  type = string
  default = "us-west-1"
}

# Variable configuration for Environment type, typical types can be Dev, Prod or staging
variable "environment" {
  description = "Environment Type for Resources"
  type = string
}

