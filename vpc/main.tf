locals {
  common_tags = {
    "Environment" = "${var.environment}"
    "Managed By"  = "Terraform",
    "Owned By"    = "${var.owner}"
  }
  vpc_id = try(aws_vpc.this[0].id, "")
  max_subnet_length = max(
    length(var.private_subnets),
    length(var.public_subnets),
    length(var.database_subnets),
  )
  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
}

# Get availability zones in us-east-1

# Create VPC
resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge({
    Name = format("%s-vpc", var.name)
    },
    var.vpc_tags,
    local.common_tags
  )
}
# Create Internet Gateway
resource "aws_internet_gateway" "this" {
  count  = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge({
    Name = format("%s-igw", var.name),
    },
    var.internet_gateway_tags,
    local.common_tags
  )
}

# remove default routes in default route table
resource "aws_default_route_table" "rtb" {
  count                  = var.create_vpc ? 1 : 0
  default_route_table_id = aws_vpc.this[0].default_route_table_id

  route = []

  tags = merge(
    var.default_rtb_tags,
    local.common_tags
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0
  vpc_id                  = local.vpc_id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge({
    Type = "Public"
    Name = try(var.public_subnet_names[count.index], format("${var.name}-${var.public_subnet_suffix}-%s", element(var.azs, count.index)))
    },
    var.public_subnet_tags,
    local.common_tags
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  vpc_id            = local.vpc_id
  cidr_block        = element(concat(var.private_subnets, [""]), count.index)
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null

  tags = merge({
    Type = "Private"
    Name = try(var.private_subnet_names[count.index], format("${var.name}-${var.private_subnet_suffix}-%s", element(var.azs, count.index)))
    },
    var.private_subnet_tags,
    local.common_tags
  )
}

# Create Route Table for publc subnet(s) and Associate subnets with Route Tables created
resource "aws_route_table" "public" {
  count  = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = format("%s-${var.public_subnet_suffix}", var.name)
    },
    var.public_rtb_tags,
    local.common_tags
  )
}

resource "aws_route" "public_internet_gateway" {
  count                  = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}


# Create Route Table for private subnet(s) and Associate subnets with Route Tables created
resource "aws_route_table" "private" {
  count  = var.create_vpc && length(var.private_subnets) > 0 ? 1 : 0
  vpc_id = local.vpc_id

  tags = merge(
    {
      "Name" = var.single_nat_gateway ? "${var.name}-${var.private_subnet_suffix}" : format("%s-${var.private_subnet_suffix}-%s", var.name, element(var.azs, count.index))
    },
    var.private_rtb_tags,
    local.common_tags
  )
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0
  route_table_id         = element(aws_route_table.private[*].id, count.index)
  destination_cidr_block = var.nat_gateway_destination_cidr_block
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

  timeouts {
    create = "5m"
  }
}

# Create 1 NAT Gateway (Not needed yet if resources will not be created in a private subnet)
locals {
  nat_gateway_ips = var.reuse_nat_ips ? var.external_nat_ip_ids : try(aws_eip.nat[*].id, [])
}
resource "aws_eip" "nat" {
  count      = var.create_vpc && var.enable_nat_gateway && false == var.reuse_nat_ips ? local.nat_gateway_count : 0
  vpc        = true
  depends_on = [aws_internet_gateway.this]
  tags = merge(
    {
      "Name" = format("${var.name}-eip-%s", element(var.azs, var.single_nat_gateway ? 0 : count.index))
    },
    var.nat_eip_tags,
    local.common_tags
  )
}

resource "aws_nat_gateway" "this" {
  count         = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element(local.nat_gateway_ips, var.single_nat_gateway ? 0 : count.index)
  subnet_id     = element(aws_subnet.public[*].id, var.single_nat_gateway ? 0 : count.index)

  tags = merge(
    {
      "Name" = format("${var.name}-nat-%s", element(var.azs, var.single_nat_gateway ? 0 : count.index))
    },
    var.nat_gateway_tags,
    local.common_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table_association" "public" {
  count          = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  count          = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, var.single_nat_gateway ? 0 : count.index)
}