provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "app_repo" {
  name = "my-app"
}

resource "aws_ecs_cluster" "app_cluster" {
  name = "my-app-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "my-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = <<DEFINITION
[
  {
    "name": "my-app",
    "image": "${aws_ecr_repository.app_repo.repository_url}:latest",
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "app_service" {
  name            = "my-app-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }
}
