output "this_redis_security_group_id" {
  value = aws_security_group.redis_security_group.id
}

output "this_redis_parameter_group" {
  value = aws_elasticache_parameter_group.redis_parameter_group.id
}

output "this_redis_subnet_group_name" {
  value = aws_elasticache_subnet_group.redis_subnet_group[0].name
}

output "this_redis_id" {
  value = aws_elasticache_replication_group.redis.id
}

output "this_redis_port" {
  value = var.redis_port
}

output "this_redis_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}
