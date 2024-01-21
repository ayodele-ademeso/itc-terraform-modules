resource "aws_s3_bucket" "bucket" {
  bucket = "${var.s3_bucket_name}"
  force_destroy = var.force_destroy

  tags = merge(
    var.common_tags,
    var.s3_bucket_tags
  )
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration { #var.versioning_config {}
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  index_document { #var.index_document {}
    suffix = "index.html"
  }

  error_document { #var.error_document {}
    key = "error.html"
  }
}

resource "aws_s3_bucket_cors_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule { #var.cors_rule={}
    allowed_headers = ["*"] #var.allowed_headers
    allowed_methods = ["PUT", "POST"] #var.allowed_methods
    allowed_origins = ["https://s3-website-test.hashicorp.com"] #var.allowed_origins
  }

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "index.html"
  source = "${path.module}/templates/"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_cloudfront_policy.json
}

data "aws_iam_policy_document" "s3_cloudfront_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3_distribution.iam_arn]
    }
  }
}

# {
#     "Version": "2008-10-17",
#     "Id": "PolicyForCloudFrontPrivateContent",
#     "Statement": [
#         {
#             "Sid": "AllowCloudFrontServicePrincipal",
#             "Effect": "Allow",
#             "Principal": {
#                 "Service": "cloudfront.amazonaws.com"
#             },
#             "Action": "s3:GetObject",
#             "Resource": "arn:aws:s3:::www.itc.ayodele.cloud/*",
#             "Condition": {
#                 "StringEquals": {
#                     "AWS:SourceArn": "arn:aws:cloudfront::866934333672:distribution/EN6KX7BHYFXNX"
#                 }
#             }
#         }
#     ]
# }