resource "random_id" "salt" {
  byte_length = 8
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = var.name
  description                   = var.description
  num_cache_clusters            = var.redis_clusters
  node_type                     = var.redis_node_type
  automatic_failover_enabled    = var.redis_clusters > 1 ? true : false
  engine_version                = var.redis_version
  port                          = var.redis_port
  parameter_group_name          = aws_elasticache_parameter_group.redis_parameter_group.id
  subnet_group_name             = var.subnet_group_override == null ? aws_elasticache_subnet_group.redis_subnet_group[0].name : var.subnet_group_override
  security_group_ids            = [aws_security_group.redis_security_group.id]
  apply_immediately             = var.apply_immediately
  maintenance_window            = var.redis_maintenance_window
  snapshot_window               = var.redis_snapshot_window
  snapshot_retention_limit      = var.redis_snapshot_retention_limit
  tags                          = var.tags
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  lifecycle {
    ignore_changes = [number_cache_clusters]
  }
}

resource "aws_elasticache_parameter_group" "redis_parameter_group" {
  name = "${var.name}-params"

  description = var.description

  # Strip the patch version from redis_version var
  family = var.redis_parameter_group == null ? "redis${replace(var.redis_version, "/\\.[\\d]+$/", "")}" : var.redis_parameter_group
  dynamic "parameter" {
    for_each = var.redis_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  count   = var.subnet_group_override == null ? 1 : 0
  name       = var.name_prefix
  description = "Managed by Terraform"
  subnet_ids = data.aws_subnets.redis.ids
}
