resource "aws_sfn_state_machine" "state_machine" {
  name       = var.name
  role_arn   = aws_iam_role.iam_for_sfn.arn
  definition = var.definition
  tags       = var.tags
  type       = var.type

  dynamic "logging_configuration" {
    for_each = var.type == "EXPRESS" && var.log_level != null ? [true] : []
    content {
      level                  = var.log_level
      log_destination        = "${aws_cloudwatch_log_group.stfun[0].arn}:*"
      include_execution_data = var.include_execution_data
    }
  }
}

resource "aws_cloudwatch_log_group" "stfun" {
  name = "${var.name}-logs"
  tags = var.tags
  count = var.type == "EXPRESS" && var.log_level != null ? 1 : 0
}
