output "apigw_arn" {
  description = "The ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.apigw.arn
}

output "apigw_execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.apigw.execution_arn
}

output "apigw_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.apigw.id
}

output "regional_dns" {
  value = aws_api_gateway_domain_name.example.regional_domain_name
}
