
# API Gateway
resource "aws_api_gateway_rest_api" "apigw" {
  name        = var.name
  description = var.description
  tags        = var.tags

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = var.uri
  parent_id   = aws_api_gateway_rest_api.apigw.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.apigw.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.apigw.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Assign URI to lambda via invoke arn
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.apigw.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"       # Lambda functions must be involked with POST
  type                    = "AWS_PROXY " # For Lambda proxy integration
  uri                     = var.lambda_invoke_arn
}

# Lambda link permission
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.apigw.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

# R53 DNS
resource "aws_api_gateway_domain_name" "example" {
  domain_name              = var.r53_zone_name
  regional_certificate_arn = var.acm_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_route53_record" "example" {
  name    = var.r53_hostname
  type    = "A"
  zone_id = var.r53_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.example.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.example.regional_zone_id
  }
}
