resource "aws_lb" "conduktor_load_balancer" {
  name               = "conduktor-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = data.aws_subnets.msk_public_subnets.ids
}

resource "aws_lb_target_group" "conduktor_target_group" {
  name        = "conduktor-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.msk_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "conduktor_default_listener" {
  load_balancer_arn = aws_lb.conduktor_load_balancer.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.conduktor_target_group.arn
  }
}

resource "aws_security_group" "alb_security_group" {
  name        = "conduktor-alb-sg"
  description = "Security Group for the Conduktor ALB."
  vpc_id      = data.aws_vpc.msk_vpc.id
}

resource "aws_security_group_rule" "alb_allow_office" {
  description       = "Allow traffic from office."
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = var.alb_ingress_cidrs
  security_group_id = aws_security_group.alb_security_group.id
}

resource "aws_security_group_rule" "alb_allow_to_ecs" {
  description              = "Allow traffic to ECS service."
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_security_group.id
  security_group_id        = aws_security_group.alb_security_group.id
}