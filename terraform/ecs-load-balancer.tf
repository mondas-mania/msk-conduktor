# tfsec:ignore:aws-elb-drop-invalid-headers
# tfsec:ignore:aws-elb-alb-not-public
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

  health_check {
    # Found in the CloudFormation template
    # https://github.com/conduktor/quickstart-conduktor-aws-msk/blob/main/cf-deploy/3%20-%20create%20ECS%20Service.yaml
    # path = "/platform/api/modules/health/live"
    path = "/"
  }
}

# tfsec:ignore:aws-elb-http-not-used
resource "aws_lb_listener" "conduktor_default_listener" {
  load_balancer_arn = aws_lb.conduktor_load_balancer.arn
  port              = "80"
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

# tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "alb_allow_ingress" {
  for_each          = var.alb_ingress_cidrs
  description       = "Allow traffic into the ALB. ${each.key}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = each.value
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