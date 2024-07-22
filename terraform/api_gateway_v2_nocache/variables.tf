variable "name" {
  description = "Name"
  type        = string
}

variable "hostname" {
  description = "Hostname"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone id"
  type        = string
}

variable "acm_cert_arn" {
  description = "ACM certificate ARN"
  type        = string
}

variable "lambda_name" {
  description = "Lambda name"
  type        = string
}

variable "lambda_arn" {
  description = "Lambda ARN"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "region" { default = "us-west-2" }

variable "role_arn" {
  default = "arn:aws:iam::463546384433:role/terraform-xaccount"
}