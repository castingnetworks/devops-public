resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = #####module.lambda-cld-webhook.this_lambda_arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.this.arn
}

resource "aws_lb_target_group" "this" {
  name        = "tf-${var.name}-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = module.this.this_lambda_arn
  depends_on       = [aws_lambda_permission.this]
}
  
resource "aws_lb" "this" {
  name        = "tf-${var.name}-alb"
  load_balancer_type = "application"
  internal           = "false"
  security_groups    = [aws_security_group.this.id]
  subnets            = data.aws_subnet_ids.subnets_public.ids

  access_logs {
    bucket  =  "${var.name}-logs"
    prefix  = "alb-${var.name}"
    enabled = true
  }

  tags = local.tags
}

resource "aws_security_group" "this" {
  name        = "tf-${var.name}-sg"
  description = "Inbound traffic to ${var.name}"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}
  
resource "aws_lb_listener" "cld-webhook" {
  load_balancer_arn = aws_lb.this.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-1-2019-08"
  certificate_arn   = data.aws_acm_certificate.cld-webhook.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cld-webhook.arn
  }
}
  
# Cross account AWS Access
provider "aws" {
  alias  = "root"
  region = var.region
  assume_role {
    role_arn     = "arn:aws:iam::463546384433:role/terraform-xaccount"
    session_name = "terraform-xaccount"
    external_id  = "terraform"
  }
}

resource "aws_route53_record" "cld-webhook" {
  provider  = aws.root
  zone_id = var.cld_webhook_r53_zone_id
  name    = "${var.env}-cld-webhook.${var.cld_webhook_domain}"
  type    = "A"
  alias {
    name                   = aws_lb.cld-webhook.dns_name
    zone_id                = aws_lb.cld-webhook.zone_id
    evaluate_target_health = true
  }
}