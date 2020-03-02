variable "create_iam_service_linked_role" {
  description = "Whether to create IAM service linked role for AWS ElasticSearch service. Can be only one per AWS account."
  type        = bool
  default     = false
}

variable "es_port" {
  description = "Elastic Search Port"
  type        = number
  default     = 443
}

// So this is where we add corporate network access to redis.  I'm defaulting to 127.0.0.1 if
// not set since i was too lazy to find how to not add the value if not set
variable "additional_cidr_ingress" {
  type    = string
  default = "127.0.0.1"
}


variable "domain_name" {
  description = "Domain name for Elasticsearch cluster"
  type        = string
  default     = "es-domain"
}

variable "es_version" {
  description = "Version of Elasticsearch to deploy (default 5.1)"
  type        = string
  default     = "5.1"
}

variable "instance_type" {
  description = "ES instance type for data nodes in the cluster (default t2.small.elasticsearch)"
  type        = string
  default     = "t2.small.elasticsearch"
}

variable "instance_count" {
  description = "Number of data nodes in the cluster (default 6)"
  type        = number
  default     = 6
}

variable "dedicated_master_type" {
  description = "ES instance type to be used for dedicated masters (default same as instance_type)"
  type        = string
  default     = "false"
}

variable "at_rest_encryption_enabled" {
  description = "Enable encrption at rest (only specific instance family types support it: m4, c4, r4, i2, i3 default: false)"
  type        = bool
  default     = false
}

variable "management_iam_roles" {
  description = "List of IAM role ARNs from which to permit management traffic (default ['*']).  Note that a client must match both the IP address and the IAM role patterns in order to be permitted access."
  type        = list(string)
  default     = ["*"]
}

variable "management_public_ip_addresses" {
  description = "List of IP addresses from which to permit management traffic (default []).  Note that a client must match both the IP address and the IAM role patterns in order to be permitted access."
  type        = list(string)
  default     = []
}

variable "ebs_volume_size" {
  description = "Optionally use EBS volumes for data storage by specifying volume size in GB (default 0)"
  type        = number
  default     = 0
}

variable "ebs_volume_type" {
  description = "Storage type of EBS volumes, if used (default gp2)"
  type        = string
  default     = "gp2"
}

variable "kms_key_id" {
  description = "KMS key used for elasticsearch"
  type        = string
  default     = ""
}

variable "snapshot_start_hour" {
  description = "Hour at which automated snapshots are taken, in UTC (default 0)"
  type        = number
  default     = 12
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

variable "tags" {
  description = "tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "use_prefix" {
  description = "Flag indicating whether or not to use the domain_prefix. Default: true"
  type        = bool
  default     = true
}

variable "domain_prefix" {
  description = "String to be prefixed to search domain. Default: tf-"
  type        = string
  default     = ""
}

variable "dedicated_master_threshold" {
  description = "The number of instances above which dedicated master nodes will be used. Default: 10"
  type        = number
  default     = 10
}

variable "advanced_options" {
  description = "Map of key-value string pairs to specify advanced configuration options. Note that the values for these configuration options must be strings (wrapped in quotes) or they may be wrong and cause a perpetual diff, causing Terraform to want to recreate your Elasticsearch domain on every apply."
  type        = map(string)
  default     = {
    "rest.action.multi.allow_explicit_index" = true
  }
}

variable "log_publishing_options" {
  description = "List of maps of options for publishing slow logs to CloudWatch Logs."
  type        = list(map(string))
  default     = []
}

variable "zone_awareness_config" {
type = object({
    availability_zone_count   = string
  })
  default = null
}

variable "node_to_node_encryption_enabled" {
  description = "Whether to enable node-to-node encryption."
  type        = bool
  default     = false
}

variable "zone_awareness_count" {
  description = "Zone Awareness"
  type        = string
  default     = null
}

