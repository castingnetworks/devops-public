resource "aws_cloudwatch_log_group" "es_vpc_search" {
  name = "/aws/aes/domains/${local.domain_name}/slow-search-logs"
}

resource "aws_cloudwatch_log_group" "es_vpc_index" {
  name = "/aws/aes/domains/${local.domain_name}/index-logs"
}

resource "aws_cloudwatch_log_group" "es_vpc_error" {
  name = "/aws/aes/domains/${local.domain_name}/error-logs"
}


resource "aws_cloudwatch_log_resource_policy" "es_vpc" {
  policy_name = "tf-${local.domain_name}-policy"#

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
