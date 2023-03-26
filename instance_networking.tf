
# VPC Creation
# We will need first to check available subnets, retreive them then create a new subnet

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "rainpole_vpc" {
  cidr_block = var.vpccidr
  tags = {
    "Name" = "rainpole_vpc"
  }
}

# We will need to create and define Networking subnets, subnets are required for inter-vpc communication

resource "aws_subnet" "external_Access" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "cache_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "data_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "bill_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "rbmq_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

# We will need to Create the following resources for Network communications
# Internet GW for internet access
# NAT GW for internal instance communication 
# EIP for NAT GW and Public EIP for Public-Facing LB

# First Create External Elastic IP
resource "aws_eip" "external_eip" {
  vpc = true

  tags = {
    "Name" = "External-EIP"
  }
}

# Second, create EIP for NAT GW
resource "aws_eip" "nat_gw_eip" {
  vpc = true

  tags = {
    "Name" = "NAT-EIP"
  }
}

# Create Internet GW
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.rainpole_vpc.id

  tags = {
    "Name" = "Internet_GW"
  }
}

# Create NAT GW
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.external_Access.id
  depends_on = [
    aws_internet_gateway.internet_gw
  ]

  tags = {
    "Name" = "NAT_GW"
  }
}

# Now we need to configure routing, routing requires route tables.
# Create RT for External traffic

resource "aws_route_table" "external_subnets_rt" {
  vpc_id = aws_vpc.rainpole_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }
}

# Create RT for NAT GW, NAT GW will receive a quad-zero as a default route
resource "aws_route_table" "nat_gw_subnets_rt" {
  vpc_id = aws_vpc.rainpole_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

# After Creating RTs, we need to associate RTs with Servers and Resources

resource "aws_route_table_association" "nat_gw__RTassociation__web_server" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.nat_gw_subnets_rt.id
}

resource "aws_route_table_association" "nat_gw__RTasspocation_app_server" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.nat_gw_subnets_rt.id
}

resource "aws_route_table_association" "nat_gw__RTasspocation_cache_server" {
  subnet_id      = aws_subnet.cache_subnet.id
  route_table_id = aws_route_table.nat_gw_subnets_rt.id
}

resource "aws_route_table_association" "nat_gw__RTasspocation_data_server" {
  subnet_id      = aws_subnet.data_subnet.id
  route_table_id = aws_route_table.nat_gw_subnets_rt.id
}

resource "aws_route_table_association" "nat_gw__RTasspocation_bill_server" {
  subnet_id      = aws_subnet.bill_subnet.id
  route_table_id = aws_route_table.nat_gw_subnets_rt.id
}

resource "aws_route_table_association" "nat_gw__RTasspocation_rbmq_server" {
  subnet_id      = aws_subnet.rbmq_subnet.id
  route_table_id = aws_route_table.nat_gw_subnets_rt.id
}
# Finally create RT associations for Extenral subnets

resource "aws_route_table_association" "external_traffic_route_association" {
  subnet_id      = aws_subnet.external_Access.id
  route_table_id = aws_route_table.external_subnets_rt.id
}
