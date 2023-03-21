
# This configuration contain EC2 instances configurtions resources, please refer to architecture diagram for more 
# information on applications and communication between them.


# There are 4 applications configured:
    # web_server: Public Facing Web Server for external Csutomer access
    # application_server: Receives requests/data from Web Server
    # caching_server: To store web cache, speed up data retrival for applications Server
    # data_server: To Store data 

resource "aws_instance" "web_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.web_server
  iam_instance_profile = aws_iam_instance_profile.ssmprofile.id
  key_name = aws_key_pair.ec2_keypair.key_name
  subnet_id = 
  availability_zone = 
  vpc_security_group_ids = 
  count = var.web_count
  user_data_base64 = 
  user_data_replace_on_change = true
}

resource "aws_instance" "app_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.app_Server
  iam_instance_profile = aws_iam_instance_profile.ssmprofile.id
  key_name = aws_key_pair.ec2_keypair.key_name
  subnet_id = 
  availability_zone = 
  vpc_security_group_ids = 
  count = var.app_count
  user_data_base64 = 
  user_data_replace_on_change = true
}

resource "aws_instance" "cache_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.cache_Server
  iam_instance_profile = aws_iam_instance_profile.ssmprofile.id
  key_name = aws_key_pair.ec2_keypair.key_name
  subnet_id = 
  availability_zone = 
  vpc_security_group_ids = 
  count = var.cache_count
  user_data_base64 = 
  user_data_replace_on_change = true
}

resource "aws_instance" "data_server" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.data_Server
  iam_instance_profile = aws_iam_instance_profile.ssmprofile.id
  key_name = aws_key_pair.ec2_keypair.key_name
  subnet_id = 
  availability_zone = 
  vpc_security_group_ids = 
  count = var.data_count
  user_data_base64 = 
  user_data_replace_on_change = true
}

# For ami, we need an AWS ami that supports SSM, SSM will be used to 
# manage the instances for troubleshooting and pataching.

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# Create AWS SSH Key for EC2 Instances

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

resource "aws_key_pair" "ec2_keypair" {
  key_name = "rainpoleappkey"
  public_key = tls_private_key.ssh_key.public_key_openssh
}