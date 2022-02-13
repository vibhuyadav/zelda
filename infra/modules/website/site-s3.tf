########################################################
############### AWS S3 Module ##########################
########################################################

resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = "${var.project_env}-${var.project_name}-${var.project_region}.${var.domain_name}"
  acl    = "public-read"

  website {
    index_document = var.website_index_document
    error_document = var.website_error_document
  }

  tags = {
    app-name = var.project_name
    app-env  = var.project_env
  }
}

data "aws_iam_policy_document" "aws_iam_policy_document" {
  statement {
    sid = "allow-read"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${var.project_env}-${var.project_name}-${var.project_region}.${var.domain_name}/*",
    ]

    principals {
      type = "*"
      #   identifiers = ["var.aws_cloudfront_origin_access_identity_iam_arn"]
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "aws_s3_bucket_policy" {
  bucket = aws_s3_bucket.aws_s3_bucket.id
  policy = data.aws_iam_policy_document.aws_iam_policy_document.json
}
