provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "apache_web_repo" {
  name = "apache-web-repo"
}

resource "aws_ecs_cluster" "apache_web_cluster" {
  name = "apache-web-cluster"
}

terraform import aws_iam_role.ecs_task_execution_role ecsTaskExecutionRole

resource "aws_ecs_task_definition" "apache_web_task" {
  family                   = "apache-web-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "apache-web-container",
    "image": "${aws_ecr_repository.apache_web_repo.repository_url}:latest",
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

resource "aws_ecs_service" "apache_web_service" {
  name            = "apache-web-service"
  cluster         = aws_ecs_cluster.apache_web_cluster.id
  task_definition = aws_ecs_task_definition.apache_web_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }
}
