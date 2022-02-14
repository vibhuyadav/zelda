###################################################
####### AWS Cloudfront Logging Bucket  ############
###################################################

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = "${var.project_env}-${var.project_name}-${var.project_region}-cloudfront-logs"

  lifecycle_rule {
    id      = "lifecycle_rule"
    enabled = true

    expiration {
      days = var.s3_lifecylcle_expiration_days
    }
  }
}