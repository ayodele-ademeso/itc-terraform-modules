locals {
  common_tags = {
    "Environment" = "${var.environment}"
    "Managed By"  = "Terraform",
    "Owned By"    = "Ayodele-UK"
  }
}

# Get availability zones in us-east-1

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.vpc_tags,
    local.common_tags
  )
}
# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.internet_gateway_tags,
    local.common_tags
  )
}

# remove default routes in default route table
resource "aws_default_route_table" "rtb" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route = []

  tags = merge(
    var.default_rtb_tags,
    local.common_tags
  )
}

# Create Subnets (2 private, 2 public)
resource "aws_subnet" "public01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public01_subnet_cidr
  availability_zone       = var.public01_availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.public_subnet_tags,
    local.common_tags
  )
}

resource "aws_subnet" "public02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public02_subnet_cidr
  availability_zone       = var.public02_availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.public_subnet_tags,
    local.common_tags
  )
}

resource "aws_subnet" "private01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private01_subnet_cidr
  availability_zone = var.private01_availability_zone

  tags = merge(
    var.private_subnet_tags
    , local.common_tags
  )
}

resource "aws_subnet" "private02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private02_subnet_cidr
  availability_zone = var.private02_availability_zone

  tags = merge(
    var.private_subnet_tags
    , local.common_tags
  )
}

# Create Route Table for publc subnet(s) and Associate subnets with Route Tables created
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = var.public_rtb_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(
    var.public_rtb_tags,
    local.common_tags
  )
}

resource "aws_route_table_association" "public01" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public02" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.public.id
}

# Create 1 NAT Gateway (Not needed yet if resources will not be created in a private subnet)
resource "aws_eip" "nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]
  tags = merge(
    var.eip_tags,
    local.common_tags
  )
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public01.id
  allocation_id = aws_eip.nat.id

  tags = merge(
    var.nat_gateway_tags,
    local.common_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

# Create Private route table and associate private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block     = var.private_rtb_cidr
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = merge(
    var.private_rtb_tags,
    local.common_tags
  )
}

resource "aws_route_table_association" "private01" {
  subnet_id      = aws_subnet.private01.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private02" {
  subnet_id      = aws_subnet.private02.id
  route_table_id = aws_route_table.private.id
}