################################################################################
############### Infrastructure that hosts the website ##########################
################################################################################

## Creates an S3 bucket, Cloudfront, Route53 hosted zones and records
module "website" {
  source                 = "./modules/website"
  domain_name            = var.domain_name
  project_env            = var.project_env
  project_name           = var.project_name
  project_region         = var.project_region
  website_index_document = var.website_index_document
  website_error_document = var.website_error_document
  web_acl_id             = module.extra_credit_1_security.aws_wafv2_web_acl_id
  logging_s3_bucket_name = module.extra_credit_2_logging.logging_s3_bucket_name
}

## Creates a WAF ACL that is then used by the cloudfront module for security
module "extra_credit_1_security" {
  source         = "./modules/waf"
  project_env    = var.project_env
  project_name   = var.project_name
  project_region = var.project_region
}

## Creates an S3 bucket for logging purposes. The bucket is used by cloudfront
module "extra_credit_2_logging" {
  source                        = "./modules/logging"
  project_env                   = var.project_env
  project_name                  = var.project_name
  project_region                = var.project_region
  s3_lifecylcle_expiration_days = var.s3_lifecylcle_expiration_days
}

## Creates a AWS Codepipeline that can be used to deploy app when it changes. 
module "extra_credit_3_codepipelines" {
  source                    = "./modules/codepipelines"
  tools_env                 = var.tools_env
  project_name              = var.project_name
  project_region            = var.project_region
  s3_deployment_bucket_name = module.website.s3_bucket_name
}