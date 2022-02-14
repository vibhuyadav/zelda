variable "domain_name" {
  type        = string
  description = "The domain name of the deployment"
}

variable "project_env" {
  type        = string
  description = "The env of the deployment"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "project_region" {
  type        = string
  description = "The region of the deployment"
}

variable "website_index_document" {
  type        = string
  description = "The index page"
}

variable "website_error_document" {
  type        = string
  description = "The error page"
}

variable "web_acl_id" {
  type        = string
  description = "The waf acl id that gets attached to the cloudfront"
}

variable "logging_s3_bucket_name" {
  type        = string
  description = "The name of the bucket used to store cloudfront logs"
}
