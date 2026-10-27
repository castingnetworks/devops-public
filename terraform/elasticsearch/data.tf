locals {
  domain_name = var.domain_name
  inside_vpc  = length(data.aws_subnets.es[0].ids) > 0 ? true : false
}