# tfsec:ignore:aws-ecs-enable-container-insight
resource "aws_ecs_cluster" "conduktor_cluster" {
  name = "conduktor-cluster"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.conduktor_logs.name
      }
    }
  }
}

# tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "conduktor_logs" {
  name = "conduktor-log-group"
}