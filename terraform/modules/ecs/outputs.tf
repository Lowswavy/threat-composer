output "ecs_cluster_id" {
  value = aws_ecs_cluster.test.id
}

output "ecs_service_name" {
  value = aws_ecs_service.test.name
}