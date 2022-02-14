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

variable "s3_lifecylcle_expiration_days" {
  type        = number
  description = "The number of days objects expire"
}