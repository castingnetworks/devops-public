resource "aws_security_group" "redis_security_group" {
  name        = "tf-${var.name}-sg"
  description = "Terraform-managed ElastiCache security group for ${var.name}"
  vpc_id      = data.aws_vpc.redis.id
  tags        = var.tags
}

resource "aws_security_group_rule" "redis_ingress" {
  count                    = length(data.aws_security_groups.redis.ids)
  type                     = "ingress"
  from_port                = var.redis_port
  to_port                  = var.redis_port
  protocol                 = "tcp"
  source_security_group_id = element(data.aws_security_groups.redis.ids, count.index)
  security_group_id        = aws_security_group.redis_security_group.id
}

resource "aws_security_group_rule" "redis_networks_ingress" {
  type              = "ingress"
  from_port         = var.redis_port
  to_port           = var.redis_port
  protocol          = "tcp"
  cidr_blocks       = [
    data.aws_vpc.redis.cidr_block
  ]
  security_group_id = aws_security_group.redis_security_group.id
}

resource "aws_security_group_rule" "redis_additional_cidr_ingress" {
  type              = "ingress"
  from_port         = var.redis_port
  to_port           = var.redis_port
  protocol          = "tcp"
  cidr_blocks       = [
    var.additional_cidr_ingress
  ]
  security_group_id = aws_security_group.redis_security_group.id
}