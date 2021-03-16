variable "name" {
  type    = string
  default = "The friendly name for the SNS topic"
}

variable "policy" {
  type        = string
  default     = null
  description = "The fully-formed AWS policy as JSON"
}

variable "tags" {
  default     = null
  description = "Key-value map of resource tags"
}
