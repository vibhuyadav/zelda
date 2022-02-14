################################################################################
############### Infrastructure that hosts the website ##########################
################################################################################

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

module "extra_credit_1_security" {
  source         = "./modules/waf"
  project_env    = var.project_env
  project_name   = var.project_name
  project_region = var.project_region
}

module "extra_credit_2_logging" {
  source                        = "./modules/logging"
  project_env                   = var.project_env
  project_name                  = var.project_name
  project_region                = var.project_region
  s3_lifecylcle_expiration_days = var.s3_lifecylcle_expiration_days
}

module "extra_credit_3_codepipelines" {
  source                    = "./modules/codepipelines"
  tools_env                 = var.tools_env
  project_name              = var.project_name
  project_region            = var.project_region
  s3_deployment_bucket_name = module.website.s3_bucket_name
}