###################################################
############### AWS WAF  ##########################
###################################################

resource "aws_wafv2_web_acl" "aws_wafv2_web_acl" {
  name        = "${var.project_env}-${var.project_name}-${var.project_region}-waf-acl"
  description = "WAF Acl to limit the traffic"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "${var.project_env}-${var.project_name}-${var.project_region}-waf-rule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "CA"]
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "${var.project_env}-${var.project_name}-${var.project_region}-waf-metric"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.project_env}-${var.project_name}-${var.project_region}-waf-metric"
    sampled_requests_enabled   = false
  }

  tags = {
    app-name = var.project_name
    app-env  = var.project_env
  }
}
