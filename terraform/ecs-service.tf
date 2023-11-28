resource "aws_ecs_service" "conduktor_service" {
  name                   = "conduktor"
  cluster                = aws_ecs_cluster.conduktor_cluster.id
  task_definition        = aws_ecs_task_definition.conduktor_task_definition.arn
  desired_count          = 1
  launch_type            = "EC2"
  enable_execute_command = true
  network_configuration {
    subnets         = data.aws_subnets.msk_private_subnet.ids
    security_groups = [aws_security_group.ecs_security_group.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.conduktor_target_group.arn
    container_name   = "conduktor"
    container_port   = 8080
  }

  # Can't create service until the TG is linked to an ALB
  depends_on = [
    aws_lb_listener.conduktor_default_listener
  ]
}

resource "aws_security_group" "ecs_security_group" {
  name        = "conduktor-ecs-sg"
  description = "Security Group for the Conduktor ALB."
  vpc_id      = data.aws_vpc.msk_vpc.id
}

resource "aws_security_group_rule" "ecs_allow_from_alb" {
  description              = "Allow traffic from ALB."
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_security_group.id
  security_group_id        = aws_security_group.ecs_security_group.id
}