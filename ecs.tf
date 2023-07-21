resource "aws_ecs_cluster" "fargate_cluster" {
  name = "fargate-cluster"
}

resource "aws_ecs_task_definition" "code_server_task" {
  family                = "code-server-task"
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = "256"
  memory                = "512"
  execution_role_arn    = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      "name"         : "code-server",
      "image"        : "linuxserver/code-server:latest",
      "environment"  : [
        {
          "name"  : "PUID",
          "value" : "1000"
        },
        {
          "name"  : "PGID",
          "value" : "1000"
        },
        {
          "name"  : "TZ",
          "value" : "Etc/UTC"
        },
        {
          "name"  : "HASHED_PASSWORD",
          "value" : "$arghgfhgon2i$v=19$m=5696,t=3,p=1$tBuMqhvOXDYF+G98VfksdhfkjyFyzwipwnEGA2mrRyt1bQkOQNhghgfhghggfgfdghgewaweedrvghjfgffUTWgcoNsUShmA"
        },
        {
          "name"  : "SUDO_PASSWORD_HASH",
          "value" : "$arhgfhggon2i$v=19$m=5696,t=3,p=1$tBuMqhvOXDYF++OhsguhruekrnyzwipwnEGA2mrRysgfdghfgffhggfhgfhgt1bQkOQNUTWgcoNsUShmA"
        },
        {
          "name"  : "DEFAULT_WORKSPACE",
          "value" : "/config/workspace"
        }
      ],
      "portMappings" : [
        {
          "containerPort" : 8443,
          "hostPort"      : 8443,
          "protocol"      : "tcp"
        }
      ],
      "healthCheck"  : {
        "command"     : ["CMD-SHELL", "curl -f http://localhost:8443 || exit 1"],
        "interval"    : 30,
        "timeout"     : 5,
        "retries"     : 3
      },
      "essential"    : true,
      "logConfiguration" : {
        "logDriver"  : "awslogs",
        "options" : {
          "awslogs-group" : "vscode-log",
          "awslogs-region" : "ap-southeast-1",
          "awslogs-stream-prefix" : "code-server"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "code_server_service" {
  name            = "code_server_service"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.code_server_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.main-private-1.id]
    security_groups = [aws_security_group.ecs-service-sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.vscode-target-group.arn
    container_name   = "code-server"
    container_port   = 8443
  }

  depends_on = [aws_alb_listener.vscode-alb-listener]
}
