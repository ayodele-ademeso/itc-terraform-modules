terraform {
  required_version = ">= 0.13.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.60"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "aws" { //this is needed to get certificates from acm
  alias  = "default"
  region = "us-east-1"
}