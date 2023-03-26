# As for any Infrastrcuture, it is important to provide security measures to control
# Engress and Ingress Traffic to the EC2 Instances, we will allow only specific traffic
# using specific ports.
# Web server will communicate on port 19090 
# Application server will communicate on port 19091
# Cache server will communicate on port 19092  
# DataStore server will communicate on port 19093

resource "aws_security_group" "web_srvr_traffic_ctrl_sg" {
  name        = "web_traffic_ctrl"
  description = "Control Ingress/Egress Web Traffic"
  vpc_id      = aws_vpc.rainpole_vpc.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Ingress Traffic to Web Server"
    from_port   = tonumber(var.webport)
    protocol    = "tcp"
    to_port     = tonumber(var.webport)
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Egress Traffic From Web Server"
    from_port   = 0    # This means any port
    protocol    = "-1" # Any protocol
    to_port     = 0
  }
}

resource "aws_security_group" "application_srvr_traffic_ctrl_sg" {
  name        = "app_traffic_ctrl"
  description = "Control Ingress/Egress Application Traffic"
  vpc_id      = aws_vpc.rainpole_vpc.id

  ingress {
    cidr_blocks = ["10.0.1.0/24"]
    description = "Allow Ingress Traffic from Web Server Only"
    from_port   = tonumber(var.appport)
    protocol    = "tcp"
    to_port     = tonumber(var.appport)
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Egress Traffic From App Server"
    from_port   = 0    # This means any port
    protocol    = "-1" # Any protocol
    to_port     = 0
  }
}

resource "aws_security_group" "cache_srvr_traffic_ctrl_sg" {
  name        = "cache_traffic_ctrl"
  description = "Control Ingress/Egress Cache Traffic"
  vpc_id      = aws_vpc.rainpole_vpc.id

  ingress {
    cidr_blocks = ["10.0.6.0/24"]
    description = "Allow Ingress Traffic from Application Server Only"
    from_port   = tonumber(var.cacheport)
    protocol    = "tcp"
    to_port     = tonumber(var.cacheport)
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Egress Traffic From Cache Server"
    from_port   = 0    # This means any port
    protocol    = "-1" # Any protocol
    to_port     = 0
  }
}

resource "aws_security_group" "data_srvr_traffic_ctrl_sg" {
  name        = "data_traffic_ctrl"
  description = "Control Ingress/Egress For DataStore Traffic"
  vpc_id      = aws_vpc.rainpole_vpc.id

  ingress {
    cidr_blocks = ["10.0.3.0/24"]
    description = "Allow Ingress Traffic from Data Server Only"
    from_port   = tonumber(var.dataport)
    protocol    = "tcp"
    to_port     = tonumber(var.dataport)
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Egress Traffic From Data Server"
    from_port   = 0    # This means any port
    protocol    = "-1" # Any protocol
    to_port     = 0
  }
}

resource "aws_security_group" "bill_srvr_traffic_ctrl_sg" {
  name        = "bill_traffic_ctrl"
  description = "Control Ingress/Egress For Billing Traffic"
  vpc_id      = aws_vpc.rainpole_vpc.id

  ingress {
    cidr_blocks = ["10.0.2.0/24"]
    description = "Allow Ingress Traffic from Application Server Only"
    from_port   = tonumber(var.billport)
    protocol    = "tcp"
    to_port     = tonumber(var.billport)
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Egress Traffic From Application Server"
    from_port   = 0    # This means any port
    protocol    = "-1" # Any protocol
    to_port     = 0
  }
}

resource "aws_security_group" "rbmq_srvr_traffic_ctrl_sg" {
  name        = "rbmq_traffic_ctrl"
  description = "Control Ingress/Egress For RabbitMQ Traffic"
  vpc_id      = aws_vpc.rainpole_vpc.id

  ingress {
    cidr_blocks = ["10.0.2.0/24"]
    description = "Allow Ingress Traffic from Application Server Only"
    from_port   = tonumber(var.rbmqport)
    protocol    = "tcp"
    to_port     = tonumber(var.rbmqport)
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Egress Traffic From Application Server"
    from_port   = 0    # This means any port
    protocol    = "-1" # Any protocol
    to_port     = 0
  }
}