# What does zelda do?
This project deploys an S3 bucket hosting a static website. The bucket is then distributed across using a CDN, in this case AWS Cloudfront. The Cloudfront uses WAF with a simple rate limmitter rule to protect against DDOS and Logging mechanisms to store Cloudfront logs in the S3 bucket.This project also contains the source code of the app that is being deployed. In this case, it's a simple app with two static pages - index.html and 404.html.

This project also deploys a CI/CD infrastructure for the app using AWS CodePipelines. So whenver this repository is updated, it triggers and build in the AWS Account.

# How to run?
Make sure you have the following installed in the system
* Terraform v0.15.4. This might work with Terraform v1 and above but has not been tested for that.
* An AWS Account to deploy to and use us-east-1 as that is a requirement for some of the cloudfront resources.
* A hosted domain of sorts. I used AWS Route53 to create a domain that I have used here.

Clone this repository
```
git clone https://github.com/vibhuyadav/zelda.git
```

Change directory to infra

```
cd infra
```

First, initialize the terraform so it can download all the modules needed.
```
terraform init
```

Once initialized, feel free to modify zelda.tfvars or create an environment based Terraform variables file. For example dev.tfvars could look like this

```
domain_name                     = "yourdomain.com"
tools_env                       = "tools"
project_env                     = "dev"
project_name                    = "myproject"
project_region                  = "us-east-1"
website_index_document          = "index.html"
website_error_document          = "404.html"
s3_lifecylcle_expiration_days   = 30
```

I used a free tier Terraform Cloud to deploy these resources using Github Actions. If you setup that, it's advised to use *.auto.tfvars file such that it is automatically picked by the default workspace which in this case was dev.

Your Terraform variables file will serve as an input to the infraturure deployments (extra credit - 4)

Once you have your tfvars file setup apply your terraform.

```
terraform apply --var-file=zelda.tfvars
```

This should deploy the infrastructure and provide you with few outputs that you might plug into other Terraform workspaces or CI/CD environments. (extra credit - 4)

# How to contribute?

Fork this repo if you want to contribute.
# How to improvise this?

* There are many things to improve here. Architecturally speaking, you should use multiple AWS Accounts or region or both for multi environment setup. The CI/CD should be deployed separetely in a tools account under different AWS Org OU. This has been left for the user.

* The buckets should be encrypted using KMS keys, lifecycle policies should be attached and they should be versioned

* The Cloudfront should use higher Price Classes and edge locations for production

* The Cloudfront logs in S3 should be piped to Athena database for supporting queries.

* Take the modules out of this repository and publish them on a public Terraform registry

* Support multiple backends depending on what user prefers. This [issue](https://github.com/hashicorp/terraform/issues/24929) should resolve it but till that's not available change the backend.tf file to use a backend of your choice or don't. In which case it will use your local machine. Be careful when deploying to prod and using your local machine to store state files. Uncomment .gitignore to check in those files in your repository. S3 is another great choice, just make sure to create that statestore bucket outside of this project as you will need it before deployment.

* Instead of using tfvars file using Terraform Workspaces to define your environments. I used Terraform Cloud to a certain degree but those can be defined on any system. Please refere [this](https://www.terraform.io/language/settings/backends/remote)

* Make more scm options available to connect to codestar_connection. It can be variablalized.

* Make IAM policies seperate json documents or use terraform's data.aws_iam_policy_document to create the policy document during apply. Right now some of them are inline policies

* Add more WAF rules
