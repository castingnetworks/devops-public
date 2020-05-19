# Create IAM Role
resource "aws_iam_role" "app-role" {
  name               = "tf-${var.env}-${var.app_name}-role"
  assume_role_policy = data.aws_iam_policy_document.app-assume-role-policy.json
  tags = local.tags
}


# Create IAM Policy
resource "aws_iam_policy" "app-policy" {
  name   = "tf-${var.env}-${var.app_name}-policy"
  path   = "/"
  policy = var.policy.json
}


resource "aws_iam_policy_attachment" "app-policy-attachment" {
  name       = "tf-${var.env}-${var.app_name}-policy-attach"
  role       = aws_iam_role.app-role.name
  policy_arn = aws_iam_policy.app-policy.arn
}

