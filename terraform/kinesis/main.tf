resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.name
  shard_count      = var.kinesis_shard_count
  retention_period = var.kinesis_retention_period

  tags = var.tags
}
