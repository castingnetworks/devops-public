variable "protocol" {
  type        = string
  default     = "sqs"
  description = "Protocol to use"
}

variable "endpoint" {
  type        = string
  description = "Endpoint to send data to. The contents vary with the protocol"
}

variable "topic_arn" {
  type        = string
  description = "ARN of the SNS topic to subscribe to"
}
