resource "aws_cloudwatch_log_group" "es_vpc" {
  name = "/aws/aes/domains/${aws_elasticsearch_domain.es_vpc.domain_name}/search-logs"
}

resource "aws_cloudwatch_log_resource_policy" "example" {
  policy_name = "tf-${aws_elasticsearch_domain.es_vpc.domain_name}-policy"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

