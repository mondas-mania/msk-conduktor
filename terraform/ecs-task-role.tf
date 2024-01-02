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

# trivy:ignore:AVD-AWS-0057 'no policy wildcards'
data "aws_iam_policy_document" "task_policy" {
  statement {
    sid       = "AllowECSExec"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
  }

  statement {
    sid       = "UseLogGroups"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
    ]
  }

  statement {
    sid    = "StoreInS3"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:ListBucketVersions",
      "s3:ListBucket",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging",
    ]

    resources = [
      "arn:aws:s3:::conduktor-monitoring-${random_string.bucket_random.result}/*",
      "arn:aws:s3:::conduktor-monitoring-${random_string.bucket_random.result}",
    ]
  }
}

resource "aws_iam_role" "conduktor_task_role" {
  name               = "task-role"
  path               = "/conduktor/"
  assume_role_policy = data.aws_iam_policy_document.ecs_trust_policy.json
  managed_policy_arns = concat(var.additional_task_role_policies, [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ])

  inline_policy {
    name   = "conduktor-task-policy"
    policy = data.aws_iam_policy_document.task_policy.json
  }
}
