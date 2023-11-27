data "aws_iam_policy_document" "ecs_trust_policy" {
  statement {
    sid     = "ECSTrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "conduktor_task_role" {
  name               = "task-role"
  path               = "/conduktor/"
  assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
}
