terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

locals {
  domain_name = "vinzapinfotech.com"
  common_tags = {
    Environment = "production"
    ManagedBy   = "Terraform"
    Owner       = "Vijayendra Singh"
    Project     = "vinzapinfotech"
    Website     = "https://www.vinzapinfotech.com"
  }
}

# ── S3 Bucket ──────────────────────────────────────────────
resource "aws_s3_bucket" "website" {
  bucket = local.domain_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ── CloudFront OAC ─────────────────────────────────────────
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "oac-vinzapinfotech"
  description                       = "OAC for vinzapinfotech.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ── ACM Certificate (read existing) ───────────────────────
data "aws_acm_certificate" "website" {
  domain      = local.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# ── S3 Bucket Policy ───────────────────────────────────────
resource "aws_s3_bucket_policy" "website" {
  bucket     = aws_s3_bucket.website.id
  depends_on = [aws_s3_bucket_public_access_block.website]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.website.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
          }
        }
      }
    ]
  })
}

# ── CloudFront Distribution (Free Plan Compatible) ─────────
resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "vinzapinfotech-s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  aliases             = ["vinzapinfotech.com", "www.vinzapinfotech.com"]

  # WAF Web ACL — required, bound to pricing plan subscription
  web_acl_id = "arn:aws:wafv2:us-east-1:402830379496:global/webacl/CreatedByCloudFront-7567e482/73019b07-b39c-4a18-bb5c-58abf533170e"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "vinzapinfotech-s3-origin"
    compress         = true

    viewer_protocol_policy = "redirect-to-https"

    # ✅ Managed Cache Policy: CachingOptimized (Free plan compatible)
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  # ✅ NO price_class — not allowed on Free plan
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.website.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = local.common_tags
}
