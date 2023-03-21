
# VPC Creation
# We will need first to check available subnets, retreive them then create a new subnet

data "aws_availability_zone" "available" {
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
  availability_zone = data.aws_availability_zone.available.name[0]
}

resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zone.available.name[0]
}

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zone.available.name[0]
}

resource "aws_subnet" "cache_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zone.available.name[0]
}

resource "aws_subnet" "data_subnet" {
  vpc_id            = aws_vpc.rainpole_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zone.available.name[0]
}
