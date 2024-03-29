
# Variable for Region, this value will be configured in Terraform Cloud in advance
variable "aws_region" {
  description = "AWS Region Variable"
  type        = string
  default     = "us-west-1"
}

# Variable configuration for Environment type, typical types can be Dev, Prod or staging
variable "environment" {
  description = "Environment Type for Resources"
  type        = string
}

# Variable for Web Server Type, this is important for Sentinel policy control
variable "web_server" {
  description = "Web Server Variable"
  type        = string
}

# Variable for Application Server Type, this is important for Sentinel policy control
variable "app_server" {
  description = "Application Server Variable"
  type        = string
}

# Variable for Caching Server Type, this is important for Sentinel policy control
variable "cache_server" {
  description = "Cacheing Server Variable"
  type        = string
}

# Variable for Data Server Type, this is important for Sentinel policy control
variable "data_server" {
  description = "Data Server Variable"
  type        = string
}

# Variable for Data Server Type, this is important for Sentinel policy control
variable "bill_server" {
  description = "Billing Server Variable"
  type        = string
}

# Variable for Data Server Type, this is important for Sentinel policy control
variable "rbmq_server" {
  description = "RabbitMQ Server Variable"
  type        = string
}

# Variable for the number of Web applications deployed, these applications will be managed by LBs
variable "web_count" {
  description = "Web Application Count"
  type        = number
  default     = 2
}

# Variable for the number of Application layer deployed, these applications will be managed by LBs
variable "app_count" {
  description = "Application App Count"
  type        = number
  default     = 1
}

# Variable for the number of Application layer deployed, these applications will be managed by LBs
variable "cache_count" {
  description = "Cache Application Count"
  type        = number
  default     = 1
}

# Variable for the number of Data applications deployed, these applications will be managed by LBs
variable "data_count" {
  description = "Data Application Count"
  type        = number
  default     = 1
}

# Variable for the number of Data applications deployed, these applications will be managed by LBs
variable "bill_count" {
  description = "Billing Application Count"
  type        = number
  default     = 1
}

# Variable for the number of Data applications deployed, these applications will be managed by LBs
variable "rbmq_count" {
  description = "RabbitMQ Application Count"
  type        = number
  default     = 1
}

# Create Variable for VPC CIDR Block
variable "vpccidr" {
  description = "CIDR Block for Rainpole VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Create Port number variables, althougth port numbers are already set, 
# it is good practice to define them as variables

variable "webport" {
  description = "Web Server Communication Port"
  type        = string
  default     = "9090"
}

variable "appport" {
  description = "Web Server Communication Port"
  type        = string
  default     = "9191"
}

variable "cacheport" {
  description = "Web Server Communication Port"
  type        = string
  default     = "9292"
}

variable "dataport" {
  description = "Web Server Communication Port"
  type        = string
  default     = "9393"
}

variable "billport" {
  description = "Billing Server Communication Port"
  type        = string
  default     = "9494"
}

variable "rbmqport" {
  description = "Billing Server Communication Port"
  type        = string
  default     = "9595"
}

# We will also need to Create Variables for Each Service, we will call each service by its function

variable "service" {
  description = "Name of the Service Created"
  type        = string
  default     = "fake-service"
}

# The following is required for Packer Images

variable "bucket" {
  description = "Put your HCP Packer Bucket in TFC"
}

variable "channel" {
  description = "HCP Packer Channel"
}
