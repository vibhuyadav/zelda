###################################################
############# AWS Codebuild #######################
###################################################

resource "aws_codebuild_project" "aws_codebuild_project" {
  count         = local.is_tools_env
  name          = "${var.tools_env}-${var.project_name}-${var.project_region}-codebuild-ci"
  description   = "${var.project_name} CI Job"
  build_timeout = var.codebuild_timeout
  service_role  = one(aws_iam_role.aws_iam_codebuild_role[*].arn)

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.codebuild_compute_type
    image                       = var.codebuild_image
    type                        = var.codebuild_container_type
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.tools_env}-${var.project_name}-${var.project_region}-codebuild-log-group"
      stream_name = "${var.tools_env}-${var.project_name}-${var.project_region}-codebuild-log-stream"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = var.buildspec_location
  }

  tags = {
    app-name = var.project_name
    app-env  = var.tools_env
  }
}

resource "aws_iam_role" "aws_iam_codebuild_role" {
  count = local.is_tools_env
  name  = "${var.tools_env}-${var.project_name}-${var.project_region}-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "aws_iam_codebuild_policy" {
  count = local.is_tools_env
  role  = one(aws_iam_role.aws_iam_codebuild_role[*].name)

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
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
        "${one(aws_s3_bucket.aws_s3_codepipeline_artifacts_bucket[*].arn)}/*"
      ]
    }
  ]
}
POLICY
}
