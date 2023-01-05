resource "aws_cloudwatch_log_group" "es_vpc_search" {
  name = "/aws/aes/domains/${local.domain_name}/slow-search-logs"
}

resource "aws_cloudwatch_log_group" "es_vpc_index" {
  name = "/aws/aes/domains/${local.domain_name}/index-logs"
}

resource "aws_cloudwatch_log_group" "es_vpc_error" {
  name = "/aws/aes/domains/${local.domain_name}/error-logs"
}

data "aws_iam_policy_document" "elasticsearch-log-publishing-policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]
    resources = ["arn:aws:logs:*"]
    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}
resource "aws_cloudwatch_log_resource_policy" "elasticsearch-log-publishing-policy" {
  policy_document = "${data.aws_iam_policy_document.elasticsearch-log-publishing-policy.json}"
  policy_name     = "tf-${local.domain_name}-policy"
}

