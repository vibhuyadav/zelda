##############################################################
############### AWS Route 53 Module ##########################
##############################################################

data "aws_route53_zone" "aws_route53_zone" {
  name         = var.domain_name
  private_zone = false
}

# Route53 Record for direct S3 access without CDN ##
resource "aws_route53_record" "aws_route53_record_s3" {
  zone_id = data.aws_route53_zone.aws_route53_zone.zone_id
  name    = "${var.project_env}-${var.project_name}-${var.project_region}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_s3_bucket.aws_s3_bucket.website_domain
    zone_id                = aws_s3_bucket.aws_s3_bucket.hosted_zone_id
    evaluate_target_health = false
  }
}

# resource "aws_route53_record" "aws_route53_record" {
#   zone_id = data.aws_route53_zone.aws_route53_zone.zone_id
#   name    = "${var.project_env}-${var.project_name}-${var.project-region}"
#   type    = "A"

#   alias {
#     name                   = var.cloudfront_domain_name
#     zone_id                = var.cloudfront_hosted_zone_id
#     evaluate_target_health = false
#   }
# }

