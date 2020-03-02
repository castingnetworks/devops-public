resource "aws_security_group" "es_security_group" {
  name        = "tf-${var.domain_name}-sg"
  description = "Terraform-managed ElastiSearch security group for ${var.domain_name}"
  vpc_id      = data.aws_vpc.es[0].id
  tags        = var.tags
}

resource "aws_security_group_rule" "es_ingress" {
  count                    = length(data.aws_security_groups.es[0].ids)
  type                     = "ingress"
  from_port                = var.es_port
  to_port                  = var.es_port
  protocol                 = "tcp"
  source_security_group_id = element(data.aws_security_groups.es[0].ids, count.index)
  security_group_id        = aws_security_group.es_security_group.id
}

resource "aws_security_group_rule" "es_networks_ingress" {
  type              = "ingress"
  from_port         = var.es_port
  to_port           = var.es_port
  protocol          = "tcp"
  cidr_blocks       = [
    data.aws_vpc.es[0].cidr_block
  ]
  security_group_id = aws_security_group.es_security_group.id
}

resource "aws_security_group_rule" "es_additional_cidr_ingress" {
  count   = var.additional_cidr_ingress == null ? 0 : 1
  type              = "ingress"
  from_port         = var.es_port
  to_port           = var.es_port
  protocol          = "tcp"
  cidr_blocks       = [
    var.additional_cidr_ingress
  ]
  security_group_id = aws_security_group.es_security_group.id
}