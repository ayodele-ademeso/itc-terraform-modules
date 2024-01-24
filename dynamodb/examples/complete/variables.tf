variable "region" {
  description = "Region to create resources in"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment name to use for resources"
  type        = string
  default     = "dev"
}