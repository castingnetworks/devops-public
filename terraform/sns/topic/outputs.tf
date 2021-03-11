output "this_topic_name" {
  value = aws_sns_topic.topic.name
}

output "this_topic_arn" {
  value = aws_sns_topic.topic.arn
}
