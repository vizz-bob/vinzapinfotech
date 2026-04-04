###############################################################
# Vinzapinfotech — Terraform Outputs
###############################################################

output "website_url" {
  description = "Primary website URL"
  value       = "https://www.${var.domain_name}"
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation)"
  value       = aws_cloudfront_distribution.website.id
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website.bucket
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.website.arn
}

output "ssl_certificate_arn" {
  description = "ACM SSL certificate ARN"
  value       = aws_acm_certificate.website.arn
}

output "route53_zone_id" {
  description = "Route53 zone ID"
  value       = data.aws_route53_zone.main.zone_id
}

output "deploy_command" {
  description = "Command to deploy files to S3"
  value       = "aws s3 sync ./build/ s3://${aws_s3_bucket.website.bucket}/ --delete"
}

output "invalidate_cache_command" {
  description = "Command to invalidate CloudFront cache"
  value       = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.website.id} --paths '/*'"
}
