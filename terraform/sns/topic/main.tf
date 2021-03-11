resource "aws_sns_topic" "topic" {
  name   = var.name
  tags   = var.tags
  policy = var.policy
}
