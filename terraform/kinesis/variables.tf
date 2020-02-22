variable "name" {
  description = "Name of the stream"
  type        = string
}

variable "tags" {
  description = "List of map of additional tags"
  type        = list(string)
  default     = []
}

variable "kinesis_shard_count" {
  description = "Number of shards to deploy in the stream"
  type        = number
  default     = 1
}

variable "kinesis_retention_period" {
  description = "Retention period for the data in the kinesis stream"
  type        = number
  default     = 24
}

variable "enforce_consumer_deletion" {
  description = "A boolean that indicates all registered consumers should be deregistered from the stream so that the stream can be destroyed without error. The default value is false."
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "The encryption type to use. The only acceptable values are NONE or KMS. The default value is NONE."
  type        = string
  default     = "NONE"
}

variable "kms_key_id " {
  description = "The encryption type to use. The only acceptable values are NONE or KMS. The default value is NONE."
  type        = string
  default     = null 
}

variable "shard_level_metrics" {
  description = "List of shard level metrics"
  type        = list(string)
  default     = []
}
