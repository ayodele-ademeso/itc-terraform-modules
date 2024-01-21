variable "environment"{
    description = "Name of the environment we are creating resources"
    type = string
}

variable "vpc_cidr_block"{
    description = "CIDR block to be assigned to VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "instance_tenancy"{
    description = "VPC instance tenancy. Defaults to 'default'"
    type = string
    default = "default"
}

variable "enable_dns_support"{
    description = "Whether to enable dns support on vpc"
    type = bool
    default = true
}

variable "enable_dns_hostnames"{
    description = "Whether to enable dns hostname"
    type = bool
    default = true
}

variable "vpc_tags"{
    description = "Custom tags for vpc resource"
    type        = map(string)
    default     = {}
}

variable "internet_gateway_tags"{
    description = "Custom tags for internet gateway"
    type        = map(string)
    default = {}
}

variable "public_subnet_cidr"{
    description = "CIDR for public subnets"
    type = list(string)
    default = []
}

variable "private_subnet_cidr"{
    description = "CIDR for private subnets"
    type = list(string)
    default = []
}

variable "map_public_ip_on_launch"{
    description = "Whether to attach a public on instances/resources launched in the subnet"
    type = bool
    default = false
}

variable "availability_zone"{
    description = "AZs to create subnet in"
    type = list(string)
    default = []
}

variable "public_subnet_tags"{
    description = "Custom tags for public subnets"
    type        = map(string)
    default = {}
}

variable "private_subnet_tags"{
    description = "Custom tags for private subnet"
    type        = map(string)
    default = {}
}

variable "public_rtb_cidr"{
    description = "CIDRs to route all public access to in the Public Route Table"
    type = string
    default = "0.0.0.0/0"
}

variable "private_rtb_cidr"{
    description = "CIDRs to route all public access to in the Private Route Table"
    type = string
    default = "0.0.0.0/32"
}

variable "public_rtb_tags"{
    description = "Common tags for public route table"
    type = map(string)
    default = {}
}

variable "private_rtb_tags"{
    description = "Common tags for private route table"
    type = map(string)
    default = {}
}