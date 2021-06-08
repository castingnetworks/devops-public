# Required variables.
variable "function_name" {
  type = string
}

variable "dynatrace_enabled" {
  type = bool
  default = false
}

variable "lambda_layers" {
  type = list(string)
  default = []
}

variable "dynatrace_layer" {
  type = list(string)
  default = ["arn:aws:lambda:us-west-2:725887861453:layer:Dynatrace_OneAgent_1_215_1_20210326-040705_nodejs:1"]
}

variable "dynatrace_config" {
  type = map
  default = {}
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "artifact_bucket" {
  description = "S3 Bucket with Lambda Artifacts"
  type        = string
}

variable "artifact_hash_key" {
  description = "S3 Key Location of artifact checksum hash file"
  type        = string
}

variable "artifact_zip_key" {
  description = "S3 Key Location of artifact zip file"
  type        = string
}


# Optional variables specific to this module.

variable "cloudwatch_logs" {
  description = "Set this to false to disable logging your Lambda output to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "lambda_at_edge" {
  description = "Set this to true if using Lambda@Edge, to enable publishing, limit the timeout, and allow edgelambda.amazonaws.com to invoke the function"
  type        = bool
  default     = false
}


variable "policy" {
  description = "An additional policy to attach to the Lambda function role"
  type = object({
    json = string
  })
  default = null
}

variable "trusted_entities" {
  description = "Lambda function additional trusted entities for assuming roles (trust relationship)"
  type = list(string)
  default = []
}

locals {
  publish = var.lambda_at_edge ? true : var.publish
  timeout = var.lambda_at_edge ? min(var.timeout, 5) : var.timeout
}

# Optional attributes to pass through to the resource.

variable "description" {
  type    = string
  default = null
}

variable "layers" {
  type    = list(string)
  default = null
}

variable "kms_key_arn" {
  type    = string
  default = null
}


variable "memory_size" {
  type    = number
  default = null
}

variable "publish" {
  type    = bool
  default = false
}
variable "reserved_concurrent_executions" {
  type    = number
  default = null
}

variable "tags" {
  type    = map(string)
  default = null
}

variable "timeout" {
  type    = number
  default = 3
}

variable "batch_size" {
  type = number
  default = null
}

# Optional blocks to pass through to the resource.

variable "dead_letter_config" {
  type = object({
    target_arn = string
  })
  default = null
}

variable "environment" {
  type = object({
    variables = map(string)
  })
  default = null
}

variable "tracing_config" {
  type = object({
    mode = string
  })
  default = null
}

variable "vpc_config" {
  type = object({
    env_tag       = string
    env_value     = string
    subnet_tag    = string
    subnet_value  = string
    sg_tag        = string
    sg_value      = string
  })
  default = null
}
