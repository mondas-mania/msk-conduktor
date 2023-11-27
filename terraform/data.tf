data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "availability_zones" {
  filter {
    name   = "region-name"
    values = [data.aws_region.current.name]
  }
}

data "aws_vpc" "msk_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnets" "msk_private_subnet" {
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

# 709825985650.dkr.ecr.us-east-1.amazonaws.com/conduktor/conduktor-selfhosted:1.14.0
# data "aws_ecr_image" "service_image" {
#   provider = aws.use1
#   registry_id     = "709825985650"
#   repository_name = "conduktor/conduktor-selfhosted"
#   image_tag       = "1.14.0"
# }
