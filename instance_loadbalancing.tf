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
