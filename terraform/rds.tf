resource "aws_db_subnet_group" "rds_private_subnets" {
  name       = "private-subnets"
  subnet_ids = data.aws_subnets.msk_private_subnets.ids

  tags = {
    Name = "private-subnets"
  }
}

# tfsec:ignore:aws-rds-encrypt-instance-storage-data
# tfsec:ignore:aws-rds-specify-backup-retention
# tfsec:ignore:AVD-AWS-0176 - no IAM authentication
# tfsec:ignore:AVD-AWS-0177 - no deletion protection enabled
# tfsec:ignore:aws-rds-enable-performance-insights
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
  parameter_group_name = "default.postgres15"

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
