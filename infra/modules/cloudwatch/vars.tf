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

variable "cloudfront_distribution_id" {
  type        = string
  description = "The distribution id of the cloudfront"
}

variable "period" {
  type        = string
  default     = 30
  description = "The period for evaluting the metric"
}

variable "threshold" {
  type        = string
  default     = 3
  description = "The threshold for metric to trigger"
}