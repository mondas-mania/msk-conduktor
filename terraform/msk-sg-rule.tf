resource "aws_security_group_rule" "msk_allow_from_conduktor" {
  for_each                 = toset(var.msk_security_group_ids)
  description              = "Allow traffic from Conduktor ECS Service."
  type                     = "ingress"
  from_port                = var.msk_port
  to_port                  = var.msk_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_security_group.id
  security_group_id        = each.value
}