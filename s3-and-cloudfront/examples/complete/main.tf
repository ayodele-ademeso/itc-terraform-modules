data "aws_acm_certificate" "issued" {
  domain   = "itc.ayodele.cloud"
  statuses = ["ISSUED"]
  provider = aws.default
}

module "website" {
  source = "../../"
  ##### S3 Website
  website_bucket_name = "website.itc.ayodele.cloud"
  force_destroy       = true
  s3_bucket_tags = {
    Environment = "dev"
  }

  #### Cloudfront
  cloudfront_distribution_enabled = true
  allowed_methods                 = ["GET", "HEAD"]
  cached_methods                  = ["GET", "HEAD"]
  acm_certificate_arn             = data.aws_acm_certificate.issued.arn
  minimum_protocol_version        = "TLSv1.2_2021"
  ssl_support_method              = "sni-only"
  cloudfront_tags = {
    Environment = "dev"
  }
}