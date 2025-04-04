variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}


variable "db_username" {
  description = "Database username"
  default     = "myuser"
}


variable "db_password" {
  description = "Database Password"
  sensitive   = true
}


variable "github_repo" {
  description = "GitHub repository URL"
  default     = "https://github.com/AkashKoche/my-microservice.git"
}
