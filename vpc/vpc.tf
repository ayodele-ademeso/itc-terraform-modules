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
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge({
    var.vpc_tags
  }, local.common_tags)
}
# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = var.internet_gateway_tags
  }, local.common_tags)
}

# Create Subnets (2 private, 2 public)
resource "aws_subnet" "public01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge({
    Name = var.public_subnet_tags
  }, local.common_tags)
}

resource "aws_subnet" "public02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge({
    Name = var.public_subnet_tags
  }, local.common_tags)
}

resource "aws_subnet" "private01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge({
    Name = var.private_subnet_tags
  }, local.common_tags)
}

resource "aws_subnet" "private02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge({
    Name = var.private_subnet_tags
  }, local.common_tags)
}

# Create Route Table for publc subnet(s) and Associate subnets with Route Tables created
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_rtb_cidr
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge({
    Name = var.public_rtb_tags
  }, local.common_tags)
}

resource "aws_route_table_association" "public01" {
  subnet_id      = aws_subnet.public01.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "public02" {
  subnet_id      = aws_subnet.public02.id
  route_table_id = aws_route_table.rt.id
}

# Create 1 NAT Gateway (Not needed yet if resources will not be created in a private subnet)
resource "aws_nat_gateway" "example" {
  subnet_id     = aws_subnet.public01.id

  tags = merge({
    Name = var.nat_gateway_tags
  }, local.common_tags)

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

#Output VPC variable
output "vpc-id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}