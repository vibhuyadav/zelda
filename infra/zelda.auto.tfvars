# Inputs to the Infrastructure
# Extra Credit 4

domain_name = "vibhuyadav.com"
# Note if you change tools env value, the module for codepipelines will need to be updated.
# This is because the value is feature flagged and it only deploys resources if the tools_env
# is tools. If you change this, codepipelines module will not deploy any resources. This has
# been done because the app's CI/CD only needs to be created once.
# Ideally you want to seperate out your CI/CD infrastructure from the APP Infrastructure in
# more of a tools environment.
# So for example, if you want to deploy tools and dev infrastructure in the same account and
# region, use tools_env="tools" and project_env="dev". And then when you want to deploy app
# infrastructure in prod, set tools_env="" or any random string except tools
tools_env                     = "tools"
project_env                   = "dev"
project_name                  = "zelda"
project_region                = "us-east-1"
website_index_document        = "index.html"
website_error_document        = "404.html"
s3_lifecylcle_expiration_days = 30
