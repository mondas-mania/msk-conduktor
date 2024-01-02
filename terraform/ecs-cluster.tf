# trivy:ignore:AVD-AWS-0034 'enable container insights'
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

# trivy:ignore:AVD-AWS-0017 'encrypt with CMK'
resource "aws_cloudwatch_log_group" "conduktor_logs" {
  name = "conduktor-log-group"
}