variable "environment" {
  description = "Environment name to use for resources."
  type        = string
  default     = ""
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table that will be created by this module."
  type        = string
  default     = ""
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity. The valid values are PROVISIONED and PAY_PER_REQUEST"
  type        = string
  default     = "PROVISIONED"
}

variable "read_capacity" {
  description = "Number of read units for this table. If the billing_mode is PROVISIONED, this field is required"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Number of write units for this table. If the billing_mode is PROVISIONED, this field is required."
  type        = number
  default     = null
}

variable "hash_key" {
  description = "(Required, Forces new resource) Attribute to use as the hash (partition) key"
  type        = string
  default     = ""
}

variable "attribute_name" {
  description = "Name of the attribute to be created. If the name is same as hash_key, this must be created"
  type        = string
  default     = ""
}

variable "attribute_type" {
  description = "Attribute type. Valid values are S (string), N (number), B (binary)."
  type        = string
  default     = ""
}

variable "dynamodb_tags" {
  description = "A map of tags to populate on the created table. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "A map of common tags to populate resources"
  type        = map(string)
  default     = {}
}