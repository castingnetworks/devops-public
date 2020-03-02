resource "aws_security_group" "redis_security_group" {
  name        = "tf-${var.name}-sg"
  description = "Terraform-managed ElastiCache security group for ${var.name}"
  vpc_id      = data.aws_vpc.redis.id
  tags = merge(
    {
      "Name" = "tf-${var.name}-sg"
    },
    var.tags,
  )
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

resource "aws_security_group_rule" "redis_egress" {
  count                    = length(data.aws_security_groups.redis.ids)
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
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

resource "aws_security_group_rule" "redis_cadditional_cidr_ingress" {
  count   = var.additional_cidr_ingress == null ? 0 : 1
  type              = "ingress"
  from_port         = var.redis_port
  to_port           = var.redis_port
  protocol          = "tcp"
  cidr_blocks       = [
    var.additional_cidr_ingress
  ]
  security_group_id = aws_security_group.redis_security_group.id
}