# Loadbalancing is an important requirement for any Biz. H/A is a requirement for Rainpole Inc.
# Rainpole will use Multiple Load Balancers to access the different applications configured.
# There will be two types of load balancers, public facing and internal load-balancers.
# Web Server will use a public load-balancer to receive traffic from internet and send it to multiple instances of Web Servers
# All other application servers (Application, Cache and Data) will use internal load-balancers.

# Load-Balancers will require a set of resources, this include, Internet GW for internet traffic ingress
# a NAT GW to allow communication between all internal servers
# Elastic IPs for external load balancer and NAT GW
# Load Balancers Target groups and listeners
# Route Tables for routing of traffic and associatation of instances to target groups.


# Let's first create External LB with public IP@
resource "aws_lb" "ext_lb" {
  name                             = "External Load Balancer"
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id     = aws_subnet.external_Access.id
    allocation_id = aws_eip.external_eip.id
  }
}

resource "aws_lb" "web_srvr_lb" {
  name               = "web_internal_lb"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = aws_subnet.web_subnet.id
    private_ipv4_address = "10.0.1.10"
  }
}

resource "aws_lb" "app_srvr_lb" {
  name               = "app_internal_lb"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = aws_subnet.app_subnet
    private_ipv4_address = "10.0.2.10"
  }
}

resource "aws_lb" "cache_srvr_lb" {
  name               = "cache_internal_lb"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = aws_subnet.cache_subnet.id
    private_ipv4_address = "10.0.3.10"
  }
}

resource "aws_lb" "data_srvr_lb" {
  name               = "data_internal_lb"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = aws_subnet.data_subnet.id
    private_ipv4_address = "10.0.4.10"
  }
}

# Now Create the Target groups for LBs, 
# the TGs are the subset of EC2 instances targeted by the LB

resource "aws_lb_target_group" "web_srvr_tg" {
  name     = "web_server_tg"
  port     = tonumber(var.webport)
  protocol = "tcp"
  vpc_id   = aws_vpc.rainpole_vpc.id
}

resource "aws_lb_target_group" "app_srvr_tg" {
  name     = "app_server_tg"
  port     = tonumber(var.appport)
  protocol = "tcp"
  vpc_id   = aws_vpc.rainpole_vpc.id
}

resource "aws_lb_target_group" "cache_srvr_tg" {
  name     = "cache_server_tg"
  port     = tonumber(var.cacheport)
  protocol = "tcp"
  vpc_id   = aws_vpc.rainpole_vpc.id
}

resource "aws_lb_target_group" "data_srvr_tg" {
  name     = "data_server_tg"
  port     = tonumber(var.dataport)
  protocol = "tcp"
  vpc_id   = aws_vpc.rainpole_vpc.id
}

# The next requirement is to configure LB Listeners for reach server/application

resource "aws_lb_listener" "web_srvr_lb_listener" {
  load_balancer_arn = aws_lb.ext_lb.arn
  port              = var.webport
  protocol          = "tcp"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_srvr_tg.arn
  }
}

resource "aws_lb_listener" "app_srvr_lb_listener" {
  load_balancer_arn = aws_lb.app_srvr_lb.arn
  port              = var.appport
  protocol          = "tcp"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_srvr_tg.arn
  }
}

resource "aws_lb_listener" "cache_srvr_lb_listener" {
  load_balancer_arn = aws_lb.cache_srvr_lb.arn
  port              = var.cacheport
  protocol          = "tcp"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cache_srvr_tg.arn
  }
}

resource "aws_lb_listener" "data_srvr_lb_listener" {
  load_balancer_arn = aws_lb.data_srvr_lb.arn
  port              = var.dataport
  protocol          = "tcp"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.data_srvr_tg.arn
  }
}

# Finally we have to attach the instances with each target group

resource "aws_lb_target_group_attachment" "web_srvr_lb_tg_attachment" {
  count            = var.web_count
  target_group_arn = aws_lb_target_group.web_srvr_tg.arn
  target_id        = aws_instance.web_server[count.index].id
  port             = tonumber(var.webport)
}

resource "aws_lb_target_group_attachment" "app_srvr_lb_tg_attachment" {
  count            = var.app_count
  target_group_arn = aws_lb_target_group.app_srvr_tg.arn
  target_id        = aws_instance.app_server[count.index].id
  port             = tonumber(var.appport)
}

resource "aws_lb_target_group_attachment" "cache_srvr_lb_tg_attachment" {
  count            = var.cache_count
  target_group_arn = aws_lb_target_group.cache_srvr_tg.arn
  target_id        = aws_instance.cache_server[count.index].id
  port             = tonumber(var.cacheport)
}

resource "aws_lb_target_group_attachment" "data_srvr_lb_tg_attachment" {
  count            = var.data_count
  target_group_arn = aws_lb_target_group.data_srvr_tg.arn
  target_id        = aws_instance.data_server[count.index].id
  port             = tonumber(var.dataport)
}
