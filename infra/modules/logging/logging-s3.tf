###################################################
####### AWS Cloudfront Logging Bucket  ############
###################################################

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = "${var.project_env}-${var.project_name}-${var.project_region}-cloudfront-logs"
}

resource "aws_s3_bucket_lifecycle_configuration" "aws_s3_bucket_lifecycle_configuration" {
  bucket = aws_s3_bucket.aws_s3_bucket.id

  rule {
    id = "lifecycle_rule"
    status = "Enabled"
    expiration {
      days = var.s3_lifecylcle_expiration_days
    }
  }
}