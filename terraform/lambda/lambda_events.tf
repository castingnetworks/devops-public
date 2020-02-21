resource "aws_lambda_event_source_mapping" "dynamo-to-ddb-stream-to-sqs-map" {
  batch_size        = var.batch_size
  enabled           = true
  event_source_arn  = var.source_arn
  function_name     = var.function.arn
  starting_position = "LATEST"
}