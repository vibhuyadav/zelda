output "logging_s3_bucket_name" {
  value = aws_s3_bucket.aws_s3_bucket.bucket
}

# output "logging_s3_bucket_domain_name" {
#     value = aws_s3_bucket.aws_s3_bucket.bucket.bucket_domain_name
# }