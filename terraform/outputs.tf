output "ecs_cluster_name" {
  value = aws_ecs_cluster.microservice.name
}


output "rds_endpoint" {
  value = aws_db_instance.microservice.endpoint
}


output "ecr_repository_url" {
  value = aws_ecr_repository.microservice.repository_url
}
