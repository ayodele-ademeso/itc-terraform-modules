variable "create_vpc" {
  description = "Controls if VPC should be created"
  type        = bool
  default     = true
}

variable "create_igw" {
  description = "Determines if an Internet Gateway will be created or not. If set to false, no Internet Gateway will be created but the correct routes will still be propagated."
  type        = bool
  default     = true
}

variable "owner" {
  description = "Describes the owner of resources provisioned. Used in common tags for all resources"
  type        = string
  default     = null
}

variable "environment" {
  description = "Name of the environment we are creating resources"
  type        = string
  default     = null
}

variable "name" {
  description = "Name to be used on all resources as identifier"
  type        = string
  default     = null
}

variable "region" {
  description = "The region where resources should be created"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block to be assigned to VPC"
  type        = string
  default     = "0.0.0.0/0"
}

variable "azs" {
  description = "A list of availability zone names or ids in the region"
  type        = list(string)
  default     = []
}

variable "instance_tenancy" {
  description = "VPC instance tenancy. Defaults to 'default'"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "Whether to enable dns support on vpc"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable dns hostname"
  type        = bool
  default     = true
}

variable "vpc_tags" {
  description = "Custom tags for vpc resource"
  type        = map(string)
  default     = {}
}

variable "internet_gateway_tags" {
  description = "Custom tags for internet gateway"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Custom tags for nat gateway"
  type        = map(string)
  default     = {}
}

variable "nat_eip_tags" {
  description = "Custom tags for elastic ip"
  type        = map(string)
  default     = {}
}

variable "default_rtb_tags" {
  description = "Custom tags for default route table"
  type        = map(string)
  default     = {}
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Whether to attach a public on instances/resources launched in the subnet"
  type        = bool
  default     = false
}

variable "public_subnet_suffix" {
  description = "Suffix to append to public subnet names"
  type        = string
  default     = "public"
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnet names"
  type        = string
  default     = "private"
}

variable "database_subnet_suffix" {
  description = "Suffix to append to database subnet names"
  type        = string
  default     = "db"
}

variable "one_nat_gateway_per_az" {
  description = "Should we create one NAT gateway per AZ or use one per region. In some cases, you may need one NAT per AZ due to limitations in how IP addresses are allocated"
  type        = bool
  default     = false
}

variable "public_subnet_tags" {
  description = "Custom tags for public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Custom tags for private subnets"
  type        = map(string)
  default     = {}
}

variable "database_subnet_tags" {
  description = "Custom tags for database subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_names" {
  description = "Explicit values to use in the `Name` tag on public subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "private_subnet_names" {
  description = "Explicit values to use in the `Name` tag on private subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "database_subnet_names" {
  description = "Explicit values to use in the `Name` tag on database subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "public_rtb_tags" {
  description = "Common tags for public route table"
  type        = map(string)
  default     = {}
}

variable "private_rtb_tags" {
  description = "Common tags for private route table"
  type        = map(string)
  default     = {}
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "reuse_nat_ips" {
  description = "Should be true if you don't want EIPs to be created for your NAT Gateways and let them reuse one IP instance per AZ."
  type        = bool
  default     = false
}

variable "external_nat_ip_ids" {
  description = "List of EIP IDs to be assigned to the NAT Gateways"
  type        = list(string)
  default     = []
}

variable "nat_gateway_destination_cidr_block" {
  description = "The destination CIDR block to which the NAT gateway will route traffic. Default is 0.0.0.0/0."
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_rtb_cidr" {
  description = "CIDRs to route all public access to in the Public Route Table"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_rtb_cidr" {
  description = "CIDRs to route all public access to in the Private Route Table"
  type        = string
  default     = "0.0.0.0/0"
}