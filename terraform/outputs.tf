output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.website.id
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.website.arn
}

output "ssl_certificate_arn" {
  value = data.aws_acm_certificate.website.arn
}

output "deploy_command" {
  value = "aws s3 sync ./dist/ s3://${aws_s3_bucket.website.bucket}/ --delete"
}
