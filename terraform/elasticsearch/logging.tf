resource "aws_cloudwatch_log_group" "es_vpc_search" {
  name = "/aws/aes/domains/${aws_elasticsearch_domain.es[0].domain_name}/slow-search-logs"
}

resource "aws_cloudwatch_log_group" "es_vpc_index" {
  name = "/aws/aes/domains/${aws_elasticsearch_domain.es[0].es_vpc.domain_name}/index-logs"
}

resource "aws_cloudwatch_log_group" "es_vpc_error" {
  name = "/aws/aes/domains/${aws_elasticsearch_domain.es_vpc.domain_name}/error-logs"
}

resource "aws_cloudwatch_log_resource_policy" "es_vpc" {
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

