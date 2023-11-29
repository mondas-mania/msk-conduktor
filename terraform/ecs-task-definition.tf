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
      name : "conduktor-platform",
      image : "conduktor/conduktor-platform:${var.conduktor_console_image_tag}",
      cpu : 0,
      portMappings : [
        {
          "name" : "conduktor-8080-tcp",
          "containerPort" : 8080,
          "hostPort" : 8080,
          "protocol" : "tcp",
          "appProtocol" : "http"
        }
      ],
      essential : true,
      environmentFiles : [],
      linuxParameters : {
        initProcessEnabled : true
      }
      mountPoints : [],
      volumesFrom : [],
      environment : [
        {
          name : "CDK_ORGANIZATION_NAME"
          value : "Test Organization"
        },
        {
          name : "CDK_LISTENING_PORT"
          value : "8080"
        },
        {
          name : "CDK_ROOT_LOG_LEVEL"
          value : "DEBUG"
        },
        {
          name : "CDK_DATABASE_HOST"
          value : aws_db_instance.conduktor_state_db.address
        },
        {
          name : "CDK_DATABASE_PORT"
          value : tostring(aws_db_instance.conduktor_state_db.port)
        },
        {
          name : "CDK_DATABASE_NAME"
          value : aws_db_instance.conduktor_state_db.db_name
        },
        {
          name : "CDK_DATABASE_USERNAME"
          value : aws_db_instance.conduktor_state_db.username
        },
        {
          name : "CDK_MONITORING_CALLBACK-URL",
          value : "http://localhost:8080/monitoring/api/"
        },
        {
          name : "CDK_MONITORING_CORTEX-URL",
          value : "http://localhost:9009/"
        },
        {
          name : "CDK_MONITORING_ALERT-MANAGER-URL",
          value : "http://localhost:9010/"
        },
        {
          name : "CDK_MONITORING_NOTIFICATIONS-CALLBACK-URL",
          value : "http://localhost:8080"
        }
      ],
      secrets : [
        {
          name : "CDK_ADMIN_EMAIL",
          valueFrom : aws_ssm_parameter.conduktor_email.arn
        },
        {
          name : "CDK_ADMIN_PASSWORD",
          valueFrom : aws_ssm_parameter.conduktor_password.arn
        },
        {
          name : "CDK_DATABASE_PASSWORD",
          valueFrom : aws_ssm_parameter.postgres_password.arn
        }
      ],
      ulimits : [],
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : "conduktor-log-group",
          awslogs-region : "eu-central-1",
          awslogs-stream-prefix : "ecs"
        },
        secretOptions : []
      }
    },

    {
      name : "conduktor-monitoring",
      image : "conduktor/conduktor-platform-cortex:${var.conduktor_monitoring_image_tag}",
      cpu : 0,
      portMappings : [
        {
          name : "conduktor-monitoring-9009-tcp",
          containerPort : 9009,
          hostPort : 9009,
          protocol : "tcp"
        },
        {
          name : "conduktor-monitoring-9010-tcp",
          containerPort : 9010,
          hostPort : 9010,
          protocol : "tcp"
        },
        {
          name : "conduktor-monitoring-9090-tcp",
          containerPort : 9090,
          hostPort : 9090,
          protocol : "tcp"
        }
      ],
      essential : false,
      environment : [
        {
          name : "CDK_CONSOLE-URL",
          value : "http://localhost:8080"
        },
        {
          name : "CORTEX_ROOT_LOG_LEVEL",
          value : "DEBUG"
        },
        {
          name : "CORTEX_ALERT_ROOT_LOG_LEVEL",
          value : "DEBUG"
        },
        {
          name : "PROMETHEUS_ROOT_LOG_LEVEL",
          value : "DEBUG"
        }
      ],
      environmentFiles : [],
      mountPoints : [],
      volumesFrom : [],
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : "conduktor-log-group",
          awslogs-region : "eu-central-1",
          awslogs-stream-prefix : "ecs"
        },
        secretOptions : []
      }
    }
  ])
}