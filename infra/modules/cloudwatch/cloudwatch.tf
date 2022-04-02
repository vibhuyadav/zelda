resource "aws_cloudwatch_metric_alarm" "aws_cloudwatch_metric_alarm" {
  alarm_name          = "${var.project_env}-${var.project_name}-${var.project_region}-Error-Rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = var.period
  threshold           = var.threshold
  statistic           = "Average"

  metric_name = "${var.project_env}-${var.project_name}-${var.project_region}-5xx"
  namespace   = "AWS/CloudFront"

  treat_missing_data = "notBreaching"
  actions_enabled    = true
  alarm_actions      = [aws_sns_topic.aws_sns_topic.arn]

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    Region         = "Global"
  }
}

resource "aws_sns_topic" "aws_sns_topic" {
  name = "${var.project_env}-${var.project_name}-${var.project_region}-notification-topic"
}