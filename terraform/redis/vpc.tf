data "aws_vpc" "redis" {
  tags = {
    "${var.vpc_config.env_tag}" = var.vpc_config.env_value
  }
}

data "aws_subnet_ids" "redis" {
  vpc_id = data.aws_vpc.redis.id
  tags = {
    "${var.vpc_config.subnet_tag}" = var.vpc_config.subnet_value
  }
}

data "aws_security_groups" "redis" {
  tags = {
    "${var.vpc_config.sg_tag}"  = var.vpc_config.sg_value,
    "${var.vpc_config.env_tag}" = var.vpc_config.env_value
  }
}