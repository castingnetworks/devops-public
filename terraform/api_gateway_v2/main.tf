resource "aws_apigatewayv2_api" "api" {
  name          = var.name
  protocol_type = "HTTP"
  description   = var.name
  target        = var.lambda_arn
  tags          = var.tags
  
}

resource "aws_lambda_permission" "apigw_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name       = var.hostname
  domain_name_configuration {
    certificate_arn = var.acm_cert_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
  tags              = var.tags
}

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id        = aws_apigatewayv2_api.api.id
  domain_name   = aws_apigatewayv2_domain_name.api.id
  stage         = "$default"
}

resource "aws_route53_record" "api" {
  zone_id = var.route53_zone_id
  name    = aws_apigatewayv2_domain_name.api.domain_name
  type    = "A"

  alias {
    name                   = element(tolist(aws_apigatewayv2_domain_name.api.domain_name_configuration), 0).target_domain_name
    zone_id                = element(tolist(aws_apigatewayv2_domain_name.api.domain_name_configuration), 0).hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_apigatewayv2_integration" "api" {
  api_id           = aws_apigatewayv2_api.api.id
  description      = "Integration"
  integration_type = "AWS_PROXY"
  integration_uri  = var.lambda_arn

  integration_method = "POST"
  connection_type    = "INTERNET"
  
  
  response_parameters {
    status_code = 301
    mappings = {
      "overwrite:header.Cache-Control" = "private,no-cache-no-store"
    }
  }
}
  
 resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}

