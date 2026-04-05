###############################################################
# Vinzapinfotech — Terraform Infrastructure as Code
# Creates: S3 bucket, CloudFront CDN, ACM SSL certificate
# NO Route53 — DNS is managed manually at your registrar
#
# Usage:
#   terraform init
#   terraform plan
#   terraform apply
###############################################################

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Recommended: Store state in S3 for team use
  # Uncomment after creating the state bucket manually
  # backend "s3" {
  #   bucket = "vinzap-terraform-state"
  #   key    = "website/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# ── Providers ──
provider "aws" {
  region = var.aws_region
}

# CloudFront requires ACM certificate in us-east-1 specifically
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

###############################################################
# S3 BUCKET — Static Website Hosting
###############################################################
resource "aws_s3_bucket" "website" {
  bucket        = var.domain_name
  force_destroy = false

  tags = local.common_tags
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

###############################################################
# ACM SSL CERTIFICATE — Reference existing certificate
# Certificate was created manually and validated via DNS.
# We look it up by domain so Terraform never replaces it.
###############################################################
data "aws_acm_certificate" "website" {
  provider    = aws.us_east_1
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

###############################################################
# CLOUDFRONT ORIGIN ACCESS CONTROL
###############################################################
resource "aws_cloudfront_origin_access_control" "website" {
  name                              = "${var.domain_name}-oac"
  description                       = "OAC for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

###############################################################
# CLOUDFRONT DISTRIBUTION
###############################################################
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  comment             = "Vinzapinfotech CDN"
  price_class         = "PriceClass_All"
  aliases             = [var.domain_name, "www.${var.domain_name}"]
  http_version        = "http2and3"

  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-${var.domain_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.website.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Cache CSS for 1 year
  ordered_cache_behavior {
    path_pattern           = "*.css"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  # Cache JS for 1 year
  ordered_cache_behavior {
    path_pattern           = "*.js"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 31536000
    default_ttl            = 31536000
    max_ttl                = 31536000

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  # Cache images for 7 days
  ordered_cache_behavior {
    path_pattern           = "images/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    min_ttl                = 604800
    default_ttl            = 604800
    max_ttl                = 604800

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

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

  # Preserve the existing WAF web ACL
  web_acl_id = "arn:aws:wafv2:us-east-1:402830379496:global/webacl/CreatedByCloudFront-7567e482/73019b07-b39c-4a18-bb5c-58abf533170e"

  tags = local.common_tags
}

###############################################################
# S3 BUCKET POLICY — Allow CloudFront OAC only
###############################################################
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
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

###############################################################
# CLOUDWATCH ALARM — Monitor 4xx errors
###############################################################
resource "aws_cloudwatch_metric_alarm" "error_rate" {
  alarm_name          = "vinzap-4xx-error-rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Alert when 4xx errors exceed 5%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
    Region         = "Global"
  }

  tags = local.common_tags
}

###############################################################
# LOCALS
###############################################################
locals {
  common_tags = {
    Project     = "vinzapinfotech"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Vijayendra Singh"
    Website     = "https://www.vinzapinfotech.com"
  }
}
