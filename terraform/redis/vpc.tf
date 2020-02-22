data "aws_vpc" "redis" {
  tags = {
    "${var.vpc_config.tag_prefix}/env" = var.env
  }
}

data "aws_subnet_ids" "redis" {
  vpc_id = data.aws_vpc.redis.id
  tags = {
    "${var.vpc_config.tag_prefix}/subnet-tier" = "private"
  }
}

data "aws_security_groups" "redis" {
  tags = {
    "${var.vpc_config.tag_prefix}/default-sg-private" = "true",
    "${var.vpc_config.tag_prefix}/env" = var.env
  }
}
