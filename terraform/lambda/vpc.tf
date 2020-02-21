data "aws_vpc" "lambda" {
  count   = var.vpc_config == null ? 0 : 1
  tags = {
    "${var.tag_prefix}/env" = var.vpc_config.subnet_env
  }
}

data "aws_subnet_ids" "lambda" {
  count   = var.vpc_config == null ? 0 : 1
  vpc_id = data.aws_vpc.lambda[0].id
  tags = {
    "${var.tag_prefix}/subnet-tier" = "private"
  }
}

data "aws_security_groups" "lambda" {
  count   = var.vpc_config == null ? 0 : 1
  tags = {
    "${var.tag_prefix}/default-sg-private" = "true",
    "${var.tag_prefix}/env" =  var.vpc_config.subnet_env
  }
}
