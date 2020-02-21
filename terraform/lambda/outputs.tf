output "this_lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.lambda.arn
}

output "this_lambda_invoke_arn" {
  description = "The Invoke ARN of the Lambda function"
  value       = aws_lambda_function.lambda.invoke_arn
}

output "this_lambda_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.lambda.function_name
}

output "this_lambda_qualified_arn" {
  description = "The qualified ARN of the Lambda function"
  value       = aws_lambda_function.lambda.qualified_arn
}

output "this_lambda_role_arn" {
  description = "The ARN of the IAM role created for the Lambda function"
  value       = aws_iam_role.lambda.arn
}

output "this_lambda_role_name" {
  description = "The name of the IAM role created for the Lambda function"
  value       = aws_iam_role.lambda.name
}