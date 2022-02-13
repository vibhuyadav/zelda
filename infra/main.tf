################################################################################
############### Infrastructure that hosts the website ##########################
################################################################################

module "website" {
  source          = "./modules/website"
  domain_name     = var.domain_name
  project_env     = var.project_env
  project_name    = var.project_name
  project_region  = var.project_region
  website_index_document = var.website_index_document
  website_error_document = var.website_error_document
}


output "route53_record_fqdn" {
    value = module.website.route53_record_fqdn
}

output "s3_bucket_name" {
    value = module.website.s3_bucket_name
}

output "cloudfront_domain_name" {
    value = module.website.cloudfront_domain_name
}
