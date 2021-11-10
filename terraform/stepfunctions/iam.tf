// Setup Role

resource "aws_iam_role" "iam_for_sfn" {
  name = "tf-${var.name}-role"

  assume_role_policy = data.aws_iam_policy_document.sfn_assume_role_policy_document.json
}

// Assume role policy document

data "aws_iam_policy_document" "sfn_assume_role_policy_document" {

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = [
        "states.amazonaws.com"
      ]
    }
  }
}

// Create Policy

resource "aws_iam_policy" "sfn" {
  name   = "tf-${var.name}-policy"
  policy = data.aws_iam_policy_document.sfn_policy_document.json
}

resource "aws_iam_policy" "sfn_logs" {
  name   = "tf-${var.name}-logs-policy"
  policy = data.aws_iam_policy_document.sfn_logs_policy_document.json
}

// Attach Policy

resource "aws_iam_role_policy_attachment" "state_policy_attach" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.sfn.arn
}

resource "aws_iam_role_policy_attachment" "logs_state_policy_attach" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.sfn_logs.arn
}

data "aws_iam_policy_document" "sfn_logs_policy_document" {
  statement {
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries",
      "logs:PutResourcePolicy",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "sfn_policy_document" {
  source_json = var.policy != null ? var.policy.json : var.policy_json

  statement {
    actions   = [
      "states:StartExecution"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:aws:*:${data.aws_caller_identity.current.account_id}:stateMachine:${var.name}",
    ]
  }

  statement {
    actions   = [
      "states:DescribeExecution",
      "states:StopExecution"
    ]
    resources = [
      "*",
    ]
  }

  statement {
    actions   = [
      "events:PutTargets",
      "events:PutRule",
      "events:DescribeRule"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:aws:*:${data.aws_caller_identity.current.account_id}:rule/StepFunctionsGetEventsForStepFunctionsExecutionRule"
    ]
  }
}
