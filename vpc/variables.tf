variable "environment" {
  description = "Name of the environment we are creating resources"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region where resources should be created"
  type        = string
  default     = ""
}

variable "vpc_cidr" {
  description = "CIDR block to be assigned to VPC"
  type        = string
  default     = "10.0.0.0/16"
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

variable "eip_tags" {
  description = "Custom tags for elastic ip"
  type        = map(string)
  default     = {}
}

variable "public01_subnet_cidr" {
  description = "CIDR for public subnets"
  type        = string
  default     = ""
}

variable "public02_subnet_cidr" {
  description = "CIDR for public subnets"
  type        = string
  default     = ""
}

variable "private01_subnet_cidr" {
  description = "CIDR for private subnets"
  type        = string
  default     = ""
}

variable "private02_subnet_cidr" {
  description = "CIDR for private subnets"
  type        = string
  default     = ""
}

variable "map_public_ip_on_launch" {
  description = "Whether to attach a public on instances/resources launched in the subnet"
  type        = bool
  default     = false
}

variable "public01_availability_zone" {
  description = "AZs to create subnet in"
  type        = string
  default     = ""
}

variable "public02_availability_zone" {
  description = "AZs to create subnet in"
  type        = string
  default     = ""
}

variable "private01_availability_zone" {
  description = "AZs to create subnet in"
  type        = string
  default     = ""
}

variable "private02_availability_zone" {
  description = "AZs to create subnet in"
  type        = string
  default     = ""
}

variable "public_subnet_tags" {
  description = "Custom tags for public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Custom tags for private subnet"
  type        = map(string)
  default     = {}
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