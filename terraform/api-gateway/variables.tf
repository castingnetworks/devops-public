# Required variables.
variable "name" {
  type    = string
  default = "lambda-api-gateway-test"
}

variable "uri" {
  type        = string
  description = ""
}

variable "lambda_name" {}
variable "lambda_invoke_arn" {}
variable "r53_zone_id" {}
variable "r53_zone_name" {}
variable "r53_hostname" {}
variable "acm_arn" {}
# Optional variables specific to this module.

variable "cloudwatch_logs" {
  description = "Set this to false to disable logging your Lambda output to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "description" {
  type    = string
  default = null
}

variable "memory_size" {
  type    = number
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "environment" {
  type = object({
    variables = map(string)
  })
  default = null
}
