output "this_iam_role_name" {
  value       = aws_iam_role.app-role.name
}
output "this_iam_role_arn" {
  value       = aws_iam_role.app-role.arn
}

output "this_iam_policy_arn" {
  value       =aws_iam_policy.app-policy.arn
}
