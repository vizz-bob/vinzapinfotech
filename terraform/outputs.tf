###############################################################
# Vinzapinfotech — Terraform Outputs
###############################################################

output "website_url" {
  description = "Primary website URL"
  value       = "https://www.${var.domain_name}"
}

output "cloudfront_domain" {
  description = "CloudFront distribution domain — use this as your CNAME target at your registrar"
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
  value       = data.aws_acm_certificate.website.arn
}

output "manual_dns_instructions" {
  description = "DNS records to add at your domain registrar (e.g. GoDaddy, Namecheap)"
  value       = <<-EOT

    ══════════════════════════════════════════════════════════
    📌 ADD THESE DNS RECORDS AT YOUR DOMAIN REGISTRAR:
    ══════════════════════════════════════════════════════════

    Type   : CNAME
    Name   : www
    Value  : ${aws_cloudfront_distribution.website.domain_name}
    TTL    : 3600

    Type   : CNAME  (or ALIAS if your registrar supports it)
    Name   : @  (root domain)
    Value  : ${aws_cloudfront_distribution.website.domain_name}
    TTL    : 3600

    ══════════════════════════════════════════════════════════
    ✅ After adding DNS records, wait 10-30 min for propagation
    ══════════════════════════════════════════════════════════
  EOT
}

output "deploy_command" {
  description = "Command to upload your site files to S3"
  value       = "aws s3 sync ./dist/ s3://${aws_s3_bucket.website.bucket}/ --delete"
}

output "invalidate_cache_command" {
  description = "Command to clear CloudFront cache after deploying new files"
  value       = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.website.id} --paths '/*'"
}
