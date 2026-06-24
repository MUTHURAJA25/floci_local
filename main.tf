terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  access_key = "test"
  secret_key = "test"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    ecs = "http://172.17.0.2:4566"
    sts = "http://172.17.0.2:4566"
  }
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "fintech-frontend"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"

  cpu    = "512"
  memory = "1024"

  container_definitions = jsonencode([
    {
      name  = "frontend"
      image = var.image

      essential = true

      portMappings = [
        {
          containerPort = 5173
          hostPort      = 0
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "frontend" {
  name = var.service_name

  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = 1
  launch_type   = "FARGATE"
}