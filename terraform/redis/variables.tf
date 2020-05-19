/*
# These vars would be used by cloudwatch.tf and should be uncommented if we decide to use them.
variable "alarm_cpu_threshold" {
  default = "75"
}

variable "alarm_memory_threshold" {
  # 10MB
  default = "10000000"
}

variable "alarm_actions" {
  type = "list"
}
*/

variable "apply_immediately" {
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false."
  type        = bool
  default     = false
}

variable "vpc_env" {
  type = string
  default = null
}


variable "name" {
  description = "Name for the Redis replication group i.e. UserObject"
  type        = string
}

variable "name_prefix" {
  type        = string
}

variable "description" {
  description = "Description of redis cluster"
  type        = string
  default     = "Redis Cluster"
}

variable "redis_clusters" {
  description = "Number of Redis cache clusters (nodes) to create"
  type        = string
  default     = 1
}

variable "redis_node_type" {
  description = "Instance type to use for creating the Redis cache clusters"
  type        = string
  default     = "cache.m3.medium"
}

variable "redis_port" {
  type    = number
  default = 6379
}


variable "env" {
  type    = string
}

// So this is where we add corporate network access to redis.  I'm defaulting to 127.0.0.1 if
// not set since i was too lazy to find how to not add the value if not set
variable "additional_cidr_ingress" {
  type    = string
  default = null
}


# might want a map
variable "redis_version" {
  description = "Redis version to use, defaults to 3.2.10"
  type        = string
  default     = "3.2.10"
}

variable "redis_parameters" {
  description = "additional parameters modifyed in parameter group"
  type        = list(map(any))
  default     = []
}

variable "redis_maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period"
  type        = string
  default     = "fri:08:00-fri:09:00"
}

variable "redis_snapshot_window" {
  description = "The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period"
  type        = string
  default     = "06:30-07:30"
}

variable "redis_snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags for redis nodes"
  type        = map(string)
  default     = {}
}

variable "subnet_group_name" {
  description = "Subnet Group Name"
  type        = string
}

variable "at_rest_encryption_enabled" {
  description = "At rest encryption"
  type        = bool
  default     = false
}


variable "transit_encryption_enabled" {
  description = "Transit Encryption"
  type        = bool
  default     = false
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