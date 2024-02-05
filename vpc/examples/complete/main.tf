module "vpc" {
  source          = "../../"
  environment     = "dev"
  region          = "eu-west-2"
  create_vpc      = true
  vpc_cidr        = "10.0.0.0/16"
  name            = "ayodele"
  owner           = "Ayodele-UK"
  azs             = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets = ["10.0.128.0/20", "10.0.144.0/20"]

  map_public_ip_on_launch = true
  enable_nat_gateway      = true
  single_nat_gateway      = true
  enable_dns_hostnames    = true
}

variable "region" {
  description = "Specify this to configure aws provider."
  default     = "eu-west-2"
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}