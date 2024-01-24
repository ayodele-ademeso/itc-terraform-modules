module "vpc" {
  source      = "../../"
  environment = "dev"
  region      = "eu-west-2"
  vpc_cidr    = "10.0.0.0/16"
  vpc_tags = {
    Name = "ayodele-vpc"
  }
  internet_gateway_tags = {
    Name = "ayodele-igw"
  }
  public01_subnet_cidr        = "10.0.0.0/20"
  public02_subnet_cidr        = "10.0.16.0/20"
  private01_subnet_cidr       = "10.0.128.0/20"
  private02_subnet_cidr       = "10.0.144.0/20"
  public01_availability_zone  = "eu-west-2a"
  public02_availability_zone  = "eu-west-2c"
  private01_availability_zone = "eu-west-2b"
  private02_availability_zone = "eu-west-2c"
  map_public_ip_on_launch     = true
  public_subnet_tags = {
    Name = "ayodele-public-subnet"
  }
  private_subnet_tags = {
    Name = "ayodele-private-subnet"
  }
  public_rtb_cidr  = "0.0.0.0/0"
  private_rtb_cidr = "0.0.0.0/0"
  public_rtb_tags = {
    Name = "ayodele-public-rtb"
  }
  private_rtb_tags = {
    Name = "ayodele-private-rtb"
  }
  nat_gateway_tags = {
    Name = "ayodele-nat-gateway"
  }
  eip_tags = {
    Name = "ayodele-eip"
  }
  default_rtb_tags = {
    Name = "ayodele-default-rtb"
  }
}

variable "region" {
  description = "The region where the VPC will be created."
  default     = "eu-west-2"
}