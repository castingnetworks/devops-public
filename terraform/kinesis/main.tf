resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.name
  shard_count      = var.kinesis_shard_count
  retention_period = var.kinesis_retention_period
  enforce_consumer_deletion = var.enforce_consumer_deletion
  encryption_type = var.encryption_type
  kms_key_id = var.kms_key_id
  tags = var.tags
  shard_level_metrics = var.shard_level_metrics
}
