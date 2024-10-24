resource "aws_ssm_parameter" "conduktor_email" {
  name  = "/conduktor/email"
  type  = "SecureString"
  value = var.conduktor_username

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "conduktor_password" {
  name  = "/conduktor/password"
  type  = "SecureString"
  value = var.conduktor_password

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "postgres_password" {
  name  = "/conduktor/postgres_password"
  type  = "SecureString"
  value = aws_db_instance.conduktor_state_db.password
}
