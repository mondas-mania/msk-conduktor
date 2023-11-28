resource "aws_ecs_task_definition" "conduktor_task_definition" {
  family                   = "conduktor"
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  cpu    = "1024"
  memory = "3072"

  task_role_arn      = aws_iam_role.conduktor_task_role.arn
  execution_role_arn = aws_iam_role.conduktor_task_execution_role.arn

  container_definitions = jsonencode([
    {
      "name" : "conduktor",
      "image" : "conduktor/conduktor-platform",
      "cpu" : 0,
      "portMappings" : [
        {
          "name" : "conduktor-8080-tcp",
          "containerPort" : 8080,
          "hostPort" : 8080,
          "protocol" : "tcp",
          "appProtocol" : "http"
        }
      ],
      "essential" : true,
      "environmentFiles" : [],
      "linuxParameters" : {
        "initProcessEnabled" : true
      }
      "mountPoints" : [],
      "volumesFrom" : [],
      "environment" : [
        {
          "name" : "CDK_LISTENING_PORT"
          "value" : "8080"
        },
        {
          "name" : "CDK_ROOT_LOG_LEVEL"
          "value" : "DEBUG"
        }
      ],
      "secrets" : [
        {
          "name" : "CDK_ADMIN_EMAIL",
          "valueFrom" : "arn:aws:ssm:eu-central-1:187839044123:parameter/conduktor/email"
        },
        {
          "name" : "CDK_ADMIN_PASSWORD",
          "valueFrom" : "arn:aws:ssm:eu-central-1:187839044123:parameter/conduktor/password"
        }
      ],
      "ulimits" : [],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "conduktor-log-group",
          "awslogs-region" : "eu-central-1",
          "awslogs-stream-prefix" : "ecs"
        },
        "secretOptions" : []
      }
    }
  ])
}