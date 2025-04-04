resource "aws_ecs_cluster" "microservice" {
  name = "MyCluster"
}



resource "aws_ecs_task_definition" "microservice" {
  family                  = "my-task-definition"
  network_mode            = "awsvpc"
  require_compatibilities = ["FARGATE"]
  cpu                     = "256"
  memory                  = "512"


  container_definitions = jsonencode([
    {
      name = "my-container"
      image = aws_ecr_repository.microservice.repository_url
      essential = true
      environment  = [
        { name = "DB_HOST", value = aws_db_instance.microservice.endpoint },
        { name = "DB_PORT", value = "5432" },
        { name = "DN_USER", value = var.db_username },
        { name = "DB_{PASSWORD", value = var.db_password },
        { name = "DB_NAME", value = "mydatabase" }
      ]
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "microservice" {
  name             = "MyService"
  cluster          = aws_ecs_cluster.microservice.id
  task_desfinition = aws_ecs_task_definition.microservice.arn
  launch           = "FARGATE"
  desired          = 1


  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}
