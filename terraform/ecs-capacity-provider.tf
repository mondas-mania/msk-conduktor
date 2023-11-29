locals {
  ami_id = jsondecode(data.aws_ssm_parameter.ecs_optimized_image.value)["image_id"]
}

# tfsec:ignore:aws-ec2-enforce-launch-config-http-token-imds
resource "aws_launch_template" "conduktor_cluster_launch_template" {
  name_prefix            = "conduktor"
  image_id               = local.ami_id
  instance_type          = "t3.medium"
  vpc_security_group_ids = []
  update_default_version = true

  user_data = base64encode(templatefile(
    "${path.module}/scripts/node_group.sh",
    {
      cluster_name = aws_ecs_cluster.conduktor_cluster.name
    }
  ))

  iam_instance_profile {
    arn = aws_iam_instance_profile.node_instance_profile.arn
  }
}

resource "aws_autoscaling_group" "conduktor_cluster_node_group" {
  name                  = "conduktor-node-group"
  min_size              = 1
  max_size              = 1
  desired_capacity      = 1
  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.conduktor_cluster_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = data.aws_subnets.msk_private_subnet.ids

  # Will be added by ECS so needs to be specified here or else TF will remove it
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "conduktor-cluster-node"
    propagate_at_launch = true
  }
}


resource "aws_ecs_capacity_provider" "conduktor_capacity_provider" {
  name = "conduktor-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.conduktor_cluster_node_group.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "conduktor_node_capacity_provider" {
  cluster_name = aws_ecs_cluster.conduktor_cluster.name

  capacity_providers = [aws_ecs_capacity_provider.conduktor_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.conduktor_capacity_provider.name
  }
}
