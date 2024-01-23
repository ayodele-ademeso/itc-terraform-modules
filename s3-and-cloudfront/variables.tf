###############################
##### S3 Bucket Variables #####
###############################
variable "website_bucket_name" {
  description = "The name of the s3 bucket to be created."
  type        = string
  default     = ""
}
variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be deleted"
  type        = bool
  default     = false
}
variable "s3_bucket_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
variable "common_tags" {
  description = "Implements the common tags scheme"
  type        = map(any)
  default = {
    "Managed By" = "Terraform"
    "Owned By"   = "Ayodele-UK"
  }
}
variable "versioning_status" {
  description = "To enable versioning on a bucket or not"
  type        = string
  default     = "Disabled"
}
variable "website_configuration" {
  description = "Describes the website-specific config."
  type = object({
    index_document = string
    error_document = string
  })
  default = null
}
variable "cors_rule" {
  description = "Cross-Origin Resource Sharing (CORS) rules. You can add up to 100 rules."
  type = list(object({
    allowed_headers   = set(string)
    allowed_methods   = set(string)
    allow_credentials = bool
    expose_headers    = set(string)
    max_age_seconds   = number
    origins           = set(string)
  }))
  default = null
}

##################################
#### Cloudfront Variables ########
##################################
variable "cloudfront_origin" {
  description = "CloudFront origin access identity to grant access to the s3 bucket over CloudFront"
  type = object({
    iam_arn : string
  })
  default = null
}

variable "create_origin_access_control" {
  description = "Controls if CloudFront origin access control should be created"
  type        = bool
  default     = false
}

variable "cloudfront_distribution_enabled" {
  description = "Indicates whether this distribution will should be created. Default value is `true`."
  type        = bool
  default     = true
}

variable "is_ipv6_enabled" {
  description = "Specifies whether IPv6 is enabled."
  type        = bool
  default     = false
}

variable "cloudfront_distribution_comment" {
  description = "The comment originally provided with the distribution."
  type        = string
  default     = ""
}

variable "cloudfront_default_root_object" {
  description = "The name of the index document for this website. If not set, the default is index.html."
  type        = string
  default     = "index.html"
}

variable "include_logging_cookies" {
  type    = bool
  default = false
}

variable "cloudfront_logs_bucket" {
  description = "Name of the s3 bucket to store cloudfront logs"
  type        = string
  default     = ""
}

variable "logs_prefix" {
  description = "Prefix to attach to cloudfront logs" #
  type        = string
  default     = "cloudfront/"
}

variable "aliases" {
  description = "A list of aliases (subdomains) that point to this resource"
  type        = list(string)
  default     = []
}

##### Cloudfront cache settings
variable "allowed_methods" {
  description = "Allowed methods for default cache behaviour"
  type        = list(string)
  default     = []
}

variable "cached_methods" {
  description = "Cached methods for default cache behaviour"
  type        = list(string)
  default     = []
}

variable "target_origin_id" {
  description = "Target Origin for default cache behaviour"
  type        = string
  default     = ""
}

variable "restrictions" {
  description = "Geo restriction configuration block that tells CloudFront where to restrict your content (i.e. country groups)"
  type = object({
    geo_method = string # Method to use for geolocation restriction. One
    # of `none|whitelist`.
    # none | whitelist
    countries = set(string) # A list of country codes (ISO 316
    # 6a2 formats) that you want to include in your country filter. This
    # option can only be used with the `whitelist` method.
  })
  default = null
}

#### Viewer certificate variables
variable "cloudfront_default_certificate" {
  description = "Whether to use the default SSL certficate for cloudfront"
  type        = bool
  default     = false
}

variable "acm_certificate_arn" {
  description = "Certificate ARN to attach to Cloudfront distribuiton"
  type        = string
  default     = null
}

variable "minimum_protocol_version" {
  description = "Minimum SSL protocol version for certificate"
  type        = string
  default     = null
}

variable "ssl_support_method" {
  description = "SSL supported mehtod"
  type        = string
  default     = null
}

variable "cloudfront_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}