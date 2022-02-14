variable "tools_env" {
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

variable "buildspec_location" {
  type        = string
  default     = "app/build/buildspec.yml"
  description = "The location of your buildspec. If you change your app structure this will change too"
}

variable "s3_deployment_bucket_name" {
  type        = string
  description = "The name of the bucket used for deployment"
}

variable "codebuild_timeout" {
  type        = string
  default     = "5"
  description = "The timeout in minutes before codebuild dies"
}

variable "codebuild_compute_type" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
  description = "The compute type for codebuild"
}

variable "codebuild_image" {
  type        = string
  default     = "aws/codebuild/standard:5.0"
  description = "The codebuild image name. Reference this - https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html"
}

variable "codebuild_container_type" {
  type        = string
  default     = "LINUX_CONTAINER"
  description = "The OS type of the containers. Windows can also be picked"
}
