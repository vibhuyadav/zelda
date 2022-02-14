#########################################################
############### AWS Cloudfront ##########################
#########################################################

locals {
  s3_origin_id = "${var.project_env}-${var.project_name}-${var.project_region}.${var.domain_name}"
}

resource "aws_cloudfront_origin_access_identity" "aws_cloudfront_origin_access_identity" {
  comment = "static website"
}

resource "aws_cloudfront_distribution" "aws_cloudfront_distribution" {

  origin {
    domain_name = "${local.s3_origin_id}.s3.amazonaws.com"
    origin_id   = local.s3_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.aws_cloudfront_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  default_root_object = var.website_index_document
  price_class         = "PriceClass_100"

  #   aliases = [newsela.vibhuyadav.com]

  # Extra Credit 1 - Securing it via WAF
  web_acl_id = var.web_acl_id

  # Extra Credit 2 - Logging the cloudfront logs
  logging_config {
    include_cookies = false
    bucket          = "${var.logging_s3_bucket_name}.s3.amazonaws.com"
    prefix          = "${var.project_env}-${var.project_name}-${var.project_region}.${var.domain_name}"
  }
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  tags = {
    app-name = var.project_name
    app-env  = var.project_env
  }
}
