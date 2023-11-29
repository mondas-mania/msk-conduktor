data "aws_caller_identity" "current" {}

data "aws_vpc" "msk_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "msk_private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.msk_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*priv*"]
  }
}

data "aws_subnets" "msk_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.msk_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*pub*"]
  }
}

data "aws_ssm_parameter" "ecs_optimized_image" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended"
}
