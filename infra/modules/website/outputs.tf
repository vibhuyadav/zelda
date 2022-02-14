## Outputs ##
output "route53_record_fqdn" {
  value = aws_route53_record.aws_route53_record_s3.fqdn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.aws_s3_bucket.bucket
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.aws_cloudfront_distribution.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.aws_cloudfront_distribution.id
}
