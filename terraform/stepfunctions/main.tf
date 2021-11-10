resource "aws_sfn_state_machine" "state_machine" {
  name       = var.name
  role_arn   = aws_iam_role.iam_for_sfn.arn
  definition = var.definition
  tags       = var.tags
  type       = var.type

  logging_configuration {
    level                  = var.logging != null ? var.logging.level : null
    log_destination        = var.logging != null ? var.logging.log_destination : null
    include_execution_data = var.logging != null ? var.logging.include_execution_data : null
  }

  tracing_configuration {
    enabled = var.tracing != null ? var.tracing.enabled : null
  }
}
