###################################################
############# AWS Codepipeline ####################
###################################################

## Check whether the tools_env equals tools if not skip creating these resources.
locals {
  is_tools_env = var.tools_env == "tools" ? 1 : 0
}

resource "aws_codepipeline" "aws_codepipeline" {
  count    = local.is_tools_env
  name     = "${var.tools_env}-${var.project_name}-${var.project_region}-codepipeline"
  role_arn = one(aws_iam_role.aws_iam_codepipeline_role[*].arn)

  artifact_store {
    location = one(aws_s3_bucket.aws_s3_codepipeline_artifacts_bucket[*].bucket)
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = one(aws_codestarconnections_connection.aws_codestarconnections_connection_github[*].arn)
        FullRepositoryId = "vibhuyadav/zelda"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = one(aws_codebuild_project.aws_codebuild_project[*].name)
      }
    }
  }

  stage {
    name = "DevDeployment"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        "BucketName" = var.s3_deployment_bucket_name
        "Extract"    = "true"
      }
    }
  }

  stage {
    name = "ProdDeployment"

    action {
      name      = "Approval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = "1"
      configuration = {
        CustomData = "Are you sure, you want to deploy ${var.project_name}?"
      }
    }

    ## This currently is not supported and won't work. In order to make CD more robust - a list(objects) should be
    ## passed which contains env and specific buckets. Then using for_each within a dynamic block iterate over the
    ## list to create specific codepipeline's stages and actions.
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      run_order       = "2"
      version         = "1"

      configuration = {
        "BucketName" = var.s3_deployment_bucket_name
        "Extract"    = "true"
      }
    }
  }
}

resource "aws_codestarconnections_connection" "aws_codestarconnections_connection_github" {
  count         = local.is_tools_env
  name          = "${var.project_name}-codestar"
  provider_type = "GitHub"
}

resource "aws_s3_bucket" "aws_s3_codepipeline_artifacts_bucket" {
  count  = local.is_tools_env
  bucket = "${var.tools_env}-${var.project_name}-${var.project_region}-codepipeline-artifacts"
  tags = {
    app-name = var.project_name
    app-env  = var.project_env
  }
}

resource "aws_s3_bucket_acl" "aws_s3_codepipeline_artifacts_bucket_acl" {
  bucket = one(aws_s3_bucket.aws_s3_codepipeline_artifacts_bucket[*].id)
  acl    = "private"
}

resource "aws_iam_role" "aws_iam_codepipeline_role" {
  count = local.is_tools_env
  name  = "${var.tools_env}-${var.project_name}-${var.project_region}-codepipeline-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aws_iam_codepipeline_policy" {
  count = local.is_tools_env
  name  = "${var.tools_env}-${var.project_name}-${var.project_region}-codepipeline-policy"
  role  = one(aws_iam_role.aws_iam_codepipeline_role[*].id)

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${one(aws_s3_bucket.aws_s3_codepipeline_artifacts_bucket[*].arn)}",
        "${one(aws_s3_bucket.aws_s3_codepipeline_artifacts_bucket[*].arn)}/*",
        "arn:aws:s3:::${var.s3_deployment_bucket_name}",
        "arn:aws:s3:::${var.s3_deployment_bucket_name}/*"
      ]
    },
    {
        "Effect": "Allow",
        "Action": [
            "codestar-connections:CreateConnection",
            "codestar-connections:DeleteConnection",
            "codestar-connections:UseConnection",
            "codestar-connections:GetConnection",
            "codestar-connections:ListConnections",
            "codestar-connections:TagResource",
            "codestar-connections:ListTagsForResource",
            "codestar-connections:UntagResource"
        ],
        "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${one(aws_codestarconnections_connection.aws_codestarconnections_connection_github[*].arn)}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
