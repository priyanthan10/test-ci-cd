provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "app_repo" {
  name = "apache-web-repo"
}

resource "aws_ecs_cluster" "app_cluster" {
  name = "apache-web-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "apache-web-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "apache-container",
    "image": "${aws_ecr_repository.app_repo.repository_url}:latest",
    "portMappings": [
      {
        "containerPort": 80,
        "protocol": "tcp"
      }
    ]
  }
]
DEFINITION

  lifecycle {
    # Prevent Terraform from trying to destroy the ECS task definition
    prevent_destroy = true
  }
}


resource "aws_ecs_service" "app_service" {
  name            = "apache-web-service"
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
