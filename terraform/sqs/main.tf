resource "aws_sqs_queue" "this" {
  count = var.create ? 1 : 0

  name        = var.name
  name_prefix = var.name_prefix

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter_queue[0].arn
    maxReceiveCount     = var.message_max_receive
  })
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
         "AWS": [
            "${data.aws_caller_identity.current.account_id}"
         ]
      },
      "Action": "SQS:*",
      "Resource": "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.name}"
    }
  ]
}
POLICY

  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication

  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = var.tags

  depends_on = [aws_sqs_queue.deadletter_queue[0]]
}

# Dead letter queue
resource "aws_sqs_queue" "deadletter_queue" {
  count = var.create ? 1 : 0

  name        = "${var.name}-deadletter"
  name_prefix = var.name_prefix

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  max_message_size           = var.max_message_size
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  policy                     = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Principal": {
         "AWS": [
            "${data.aws_caller_identity.current.account_id}"
         ]
      },
      "Action": "SQS:*",
      "Resource": "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.name}"
    }
  ]
}
POLICY

  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication

  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds

  tags = var.tags
}
