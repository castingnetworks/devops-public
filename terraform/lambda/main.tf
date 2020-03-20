resource "aws_lambda_function" "lambda" {

  function_name                  = var.function_name
  description                    = var.description
  role                           = aws_iam_role.lambda.arn
  handler                        = var.handler
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  timeout                        = local.timeout
  publish                        = local.publish
  tags                           = var.tags
  source_code_hash               = data.aws_s3_bucket_object.lambda_hash.body
  s3_bucket                      = var.artifact_bucket
  s3_key                         = var.artifact_zip_key
  provider                       = null

  
  # Add dynamic blocks based on variables.

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config == null ? [] : [var.dead_letter_config]
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config == null ? [] : [var.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = data.aws_security_groups.lambda[0].ids
      subnet_ids         = data.aws_subnet_ids.lambda[0].ids
    }
  }
}

# Get checksum of artifact
data "aws_s3_bucket_object" "lambda_hash" {
  bucket = var.artifact_bucket
  key    = var.artifact_hash_key
}
