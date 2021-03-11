output "this_topic_name" {
  value = data.aws_sns_topic.topic.name
}

output "this_topic_arn" {
  value = data.aws_sns_topic.topic.arn
}
