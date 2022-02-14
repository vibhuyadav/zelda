output "website_endpoint" {
    value = module.website.route53_record_fqdn
}

output "security_waf_arn" {
    value = module.extra_credit_1_security.aws_wafv2_web_acl_id
}

output "logging_s3_bucket_name" {
    value = module.extra_credit_2_logging.logging_s3_bucket_name
}

output "s3_bucket_name" {
    value = module.website.s3_bucket_name
}

output "cloudfront_domain_name" {
    value = module.website.cloudfront_domain_name
}

output "codestar_connection_status" {
    value = module.extra_credit_3_codepipelines.codestar_connection_status
}
