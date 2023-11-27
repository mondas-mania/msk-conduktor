data "aws_iam_policy_document" "ec2_trust_policy" {
  statement {
    sid     = "ECSTrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node_instance_role" {
  name               = "node-instance-profile"
  path               = "/conduktor/"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
}

resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "node-instance-profile"
  role = aws_iam_role.node_instance_role.name
}
