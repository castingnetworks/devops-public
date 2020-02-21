  
output "this_kinesis_stream_arn" {
  value       = aws_kinesis_stream.kinesis_stream.arn
  description = "The Amazon Resource Name (ARN) specifying the Stream (same as id)"
}

output "this_kinesis_stream_name" {
  value       = aws_kinesis_stream.kinesis_stream.name
  description = "The unique Stream name"
}

output "this_kinesis_stream_id" {
  value       = aws_kinesis_stream.kinesis_stream.id
  description = "The unique Stream id"
}

output "this_kinesis_stream_shard_count" {
  value       = aws_kinesis_stream.kinesis_stream.shard_count
  description = "The count of Shards for this Stream"
}
