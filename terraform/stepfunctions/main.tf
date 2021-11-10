resource "aws_sfn_state_machine" "state_machine" {
  name       = var.name
  role_arn   = aws_iam_role.iam_for_sfn.arn
  definition = var.definition
  tags       = var.tags
  type       = var.type

  logging_configuration {
    level                  = var.type == "EXPRESS" ? var.log_level : null
    log_destination        = var.type == "EXPRESS" ? var.log_destination : null
    include_execution_data = var.type == "EXPRESS" ? var.include_execution_data : null
  }

  tracing_configuration {
    enabled = var.tracing_enabled
  }
}
