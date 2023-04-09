variable "ami_id" {
  description = "ID of the AMI to use for the instance"
  type = string
}

variable "instance_type" {
  description = "Instance type to use for the instance"
  type = string
}

variable "iam_instance_profile" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  description = "ID of the subnet to launch the instance in"
  type = string
}

variable "availability_zone" {
  type = string
}
variable "vpc_security_group_ids" {
  description = "List of security group IDs to assign to the instance"
  type = string
}

variable "srvr_count" {
  description = "Number of instances to launch"
  type = number
}

variable "user_data_base64" {
  type = string
}

variable "srvr_tag" {
  type = string
  default = "Web_Server"
}

variable "user_data_replace_on_change" {
  type = string
  default = true
}