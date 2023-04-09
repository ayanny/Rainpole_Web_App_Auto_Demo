
# This configuration contain EC2 instances configurtions resources, please refer to architecture diagram for more 
# information on applications and communication between them.


# There are 4 applications configured:
    # web_server: Public Facing Web Server for external Csutomer access
    # application_server: Receives requests/data from Web Server
    # caching_server: To store web cache, speed up data retrival for applications Server
    # data_server: To Store data 


module "web_server" {
  source = "./Module"

  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = var.web_server
  iam_instance_profile        = aws_iam_instance_profile.ssmprofile.id
  key_name                    = aws_key_pair.ec2_keypair.key_name
  subnet_id                   = aws_subnet.web_subnet.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.web_srvr_traffic_ctrl_sg.id]
#  srvr_count                  = var.srvr_count
  user_data_base64            = data.cloudinit_config.web_srvr_template.rendered
  #user_data_replace_on_change = var.user_data_replace_on_change

  # tags = {
  #   "Name" = var.srvr_tag
  # }
}


resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.web_server
  iam_instance_profile        = aws_iam_instance_profile.ssmprofile.id
  key_name                    = aws_key_pair.ec2_keypair.key_name
  subnet_id                   = aws_subnet.web_subnet.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.web_srvr_traffic_ctrl_sg.id]
  count                       = var.web_count
  user_data_base64            = data.cloudinit_config.web_srvr_template.rendered
  user_data_replace_on_change = true

  tags = {
    "Name" = "Web_Server"
  }
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.app_server
  iam_instance_profile        = aws_iam_instance_profile.ssmprofile.id
  key_name                    = aws_key_pair.ec2_keypair.key_name
  subnet_id                   = aws_subnet.app_subnet.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.application_srvr_traffic_ctrl_sg.id]
  count                       = var.app_count
  user_data_base64            = data.cloudinit_config.app_srvr_template.rendered
  user_data_replace_on_change = true

  tags = {
    "Name" = "Application_Server"
  }
}

resource "aws_instance" "cache_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.cache_server
  iam_instance_profile        = aws_iam_instance_profile.ssmprofile.id
  key_name                    = aws_key_pair.ec2_keypair.key_name
  subnet_id                   = aws_subnet.cache_subnet.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.cache_srvr_traffic_ctrl_sg.id]
  count                       = var.cache_count
  user_data_base64            = data.cloudinit_config.cache_srvr_template.rendered
  user_data_replace_on_change = true

  tags = {
    "Name" = "Cache_Server"
  }
}

# Instace to manage all payments created by customers
resource "aws_instance" "bill_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.bill_server
  iam_instance_profile        = aws_iam_instance_profile.ssmprofile.id
  key_name                    = aws_key_pair.ec2_keypair.key_name
  subnet_id                   = aws_subnet.bill_subnet.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.bill_srvr_traffic_ctrl_sg.id]
  count                       = var.bill_count
  user_data_base64            = data.cloudinit_config.bill_srvr_template.rendered
  user_data_replace_on_change = true

  tags = {
    "Name" = "Billing_Server"
  }
}

# Instace for RabitMQ server to manage msgs between instances
resource "aws_instance" "rbmq_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.rbmq_server
  iam_instance_profile        = aws_iam_instance_profile.ssmprofile.id
  key_name                    = aws_key_pair.ec2_keypair.key_name
  subnet_id                   = aws_subnet.rbmq_subnet.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.rbmq_srvr_traffic_ctrl_sg.id]
  count                       = var.rbmq_count
  user_data_base64            = data.cloudinit_config.rbmq_srvr_template.rendered
  user_data_replace_on_change = true

  tags = {
    "Name" = "RabbitMQ_Server"
  }
}

resource "aws_instance" "data_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.data_server
  iam_instance_profile        = aws_iam_instance_profile.ssmprofile.id
  key_name                    = aws_key_pair.ec2_keypair.key_name
  subnet_id                   = aws_subnet.app_subnet.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.data_srvr_traffic_ctrl_sg.id]
  count                       = var.data_count
  user_data_base64            = data.cloudinit_config.data_srvr_template.rendered
  user_data_replace_on_change = true

  tags = {
    "Name" = "DataStore_Server"
  }
}

# For ami, we need an AWS ami that supports SSM, SSM will be used to 
# manage the instances for troubleshooting and pataching.

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create AWS SSH Key for EC2 Instances

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "rainpoleappkey"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
