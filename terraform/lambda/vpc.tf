data "aws_vpc" "lambda" {
  count   = var.vpc_config == null ? 0 : 1
  tags = {
    "${var.vpc_config.env_tag}" = var.vpc_config.env_value
  }
}

data "aws_subnet_ids" "lambda" {
  count   = var.vpc_config == null ? 0 : 1
  vpc_id = data.aws_vpc.lambda[0].id
  tags = {
    "${var.vpc_config.subnet_tag}" = var.vpc_config.subnet_value
  }
}

data "aws_security_groups" "lambda" {
  count   = var.vpc_config == null ? 0 : 1
  tags = {
    var.vpc_config.sg_tag  = var.vpc_config.sg_value,
    "${var.vpc_config.env_tag}" = var.vpc_config.env_value
  }
}
