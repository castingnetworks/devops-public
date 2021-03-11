resource "aws_sns_topic_subscription" "topic_subscription" {
  endpoint  = var.endpoint
  protocol  = var.protocol
  topic_arn = var.topic_arn
}
