data "aws_iam_policy_document" "task_execution_policy" {
  statement {
    sid    = "SSMPermissions"
    effect = "Allow"
    resources = [
      aws_ssm_parameter.conduktor_password.arn,
      aws_ssm_parameter.conduktor_email.arn,
      aws_ssm_parameter.postgres_password.arn
    ]
    actions = ["ssm:GetParameters"]
  }
}

resource "aws_iam_role" "conduktor_task_execution_role" {
  name               = "task-execution-role"
  path               = "/conduktor/"
  assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  inline_policy {
    name   = "conduktor-execution-permissions"
    policy = data.aws_iam_policy_document.task_execution_policy.json
  }
}
