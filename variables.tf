
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

# Variable for Web Server Type, this is important for Sentinel policy control
variable "web_server" {
  description = "Web Server Variable"
  type = string
}

# Variable for Application Server Type, this is important for Sentinel policy control
variable "app_Server" {
  description = "Application Server Variable"
  type = string
}

# Variable for Caching Server Type, this is important for Sentinel policy control
variable "cache_Server" {
  description = "Cacheing Server Variable"
  type = string
}

# Variable for Data Server Type, this is important for Sentinel policy control
variable "data_Server" {
  description = "Data Server Variable"
  type = string
}



# Variable for the number of Web applications deployed, these applications will be managed by LBs
variable "web_count" {
  description = "Web Application Count"
  type = number
  default = 2
}

# Variable for the number of Application layer deployed, these applications will be managed by LBs
variable "app_count" {
    description = "Application App Count"
    type = number
    count = 1    
}

# Variable for the number of Application layer deployed, these applications will be managed by LBs
variable "cache_count" {
    description = "Cache Application Count"
    type = number
    count = 1    
}

# Variable for the number of Data applications deployed, these applications will be managed by LBs
variable "data_count" {
    description = "Data Application Count"
    type = number
    count = 1    
}