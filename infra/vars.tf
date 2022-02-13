####################################################
############### Variables ##########################
####################################################


##### Variables for Hosting Onfrastructure #####

variable "domain_name" {
    type = string
    description = "The name of the domain where you host the content"
}

variable "project_env" {
    type = string
    description = "The env of the deployment"
}

variable "project_name" {
    type = string
    description = "The name of the project"
}

variable "project_region" {
    type = string
    description = "The region of the deployment"
}

variable "website_index_document" {
    type = string
    description = "The index page"
}

variable "website_error_document" {
    type = string
    description = "The error page"
}

