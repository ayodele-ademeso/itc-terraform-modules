resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_distribution.id
    origin_id                = aws_s3_bucket.bucket.bucket_regional_domain_name
  }

  enabled             = var.cloudfront_distribution_enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.cloudfront_distribution_comment
  default_root_object = var.cloudfront_default_root_object

  # logging_config {
  #   include_cookies = var.include_logging_cookies #false
  #   bucket          = var.cloudfront_logs_bucket  #""
  #   prefix          = var.logs_prefix             #""
  # }

  aliases = var.aliases

  default_cache_behavior {                  #var.default_cache_behaviour
    allowed_methods  = var.allowed_methods  #list(string)
    cached_methods   = var.cached_methods   #list(string)
    target_origin_id = aws_s3_bucket.bucket.bucket_regional_domain_name #string

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = merge(var.cloudfront_tags,
  var.common_tags)

  viewer_certificate { #var.viewer_certificate_settings
    cloudfront_default_certificate = var.cloudfront_default_certificate
    acm_certificate_arn            = var.acm_certificate_arn
    minimum_protocol_version       = var.minimum_protocol_version #"TLSv1.2_2021"
    ssl_support_method             = var.ssl_support_method
  }
}

resource "aws_cloudfront_origin_access_control" "s3_distribution" {
  name                              = "s3_distribution_origin_access_control" #var.oac_name #string
  description                       = ""                                      #var.oac_description #string
  origin_access_control_origin_type = "s3"                                    #var.oac_origin_type #string, default is s3
  signing_behavior                  = "always"                                #var.signing_behavior #string, default is always
  signing_protocol                  = "sigv4"                                 #var.signing_protocol #signing protocol, default is sigv4
}