resource "aws_cloudfront_distribution" "s3_distribution" {
  origin { #var.cloudfront_origin {}
    domain_name              = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_distribution.id
    origin_id                = aws_s3_bucket.bucket.bucket_regional_domain_name
  }

  enabled             = true #var.cloudfront_enabled
  is_ipv6_enabled     = true #var.is_ipv6_enabled
  comment             = "My Cloudfront can Access" #var.cloudfront_distribution_comment
  default_root_object = "index.html" #var.cloudfront_default_root_object

  logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com" #var.cloudfront_logs_bucket
    prefix          = "cloudfront" #var.logs_prefix
  }

  aliases = ["mysite.example.com", "yoursite.example.com"] #var.aliases []

  default_cache_behavior { #var.default_cache_behaviour
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.bucket.bucket_regional_domain_name

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

  # Cache behavior with precedence 0
  ordered_cache_behavior { #var.ordered_cache_behaviour
    path_pattern     = "/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {}
  }

  tags = merge(var.cloudfront_tags,
        local.common_tags)

  viewer_certificate { #var.viewer_certificate_settings
    cloudfront_default_certificate = true|false
    acm_certificate_arn = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_distribution" {
  name                              = "example"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}