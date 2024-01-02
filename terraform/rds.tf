resource "aws_db_subnet_group" "rds_private_subnets" {
  name       = "private-subnets"
  subnet_ids = data.aws_subnets.msk_private_subnets.ids

  tags = {
    Name = "private-subnets"
  }
}

resource "aws_db_parameter_group" "postgres15_paramater_group" {
  name   = "postgres15"
  family = "postgres15"

  lifecycle {
    create_before_destroy = true
  }
}

# trivy:ignore:AVD-AWS-0077 'specify backup retention'
# trivy:ignore:AVD-AWS-0080 'encrypt instance storage data'
# trivy:ignore:AVD-AWS-0133 'enable performance insights'
# trivy:ignore:AVD-AWS-0176 'enable IAM auth'
# trivy:ignore:AVD-AWS-0177 'enable instance deletion protection'
resource "aws_db_instance" "conduktor_state_db" {
  identifier        = "conduktor-database"
  engine            = "postgres"
  engine_version    = "15.3"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_subnet_group_name   = aws_db_subnet_group.rds_private_subnets.name
  multi_az               = false
  port                   = 5432
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]

  db_name              = "conduktor_state"
  username             = "conduktor"
  password             = var.rds_password
  parameter_group_name = aws_db_parameter_group.postgres15_paramater_group.name

  skip_final_snapshot = true
}

resource "aws_security_group" "rds_security_group" {
  name        = "conduktor-rds-sg"
  description = "Security Group for the Conduktor PostgreSQL Database."
  vpc_id      = data.aws_vpc.msk_vpc.id

  tags = {
    "Name" = "conduktor-rds-sg"
  }
}

resource "aws_security_group_rule" "rds_allow_from_ecs" {
  description              = "Allow traffic from ECS Service."
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_security_group.id
  security_group_id        = aws_security_group.rds_security_group.id
}
