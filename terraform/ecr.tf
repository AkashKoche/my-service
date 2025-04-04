resource "aws_ecr_repository" "microservice" {
  name = "my-microservice"
}


output "ecr_repository_url" {
  value = aws_ecr_repository.microservice.repository_url
}
