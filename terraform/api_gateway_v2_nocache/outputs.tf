output "this_arn" {
  value = aws_apigatewayv2_api.api.arn
}

output "this_endpoint" {
  value = aws_apigatewayv2_api.api.api_endpoint
}

