resource "aws_ssm_parameter" "conduktor_email" {
  name  = "/conduktor/email"
  type  = "SecureString"
  value = "CHANGE_ME" # Change in console to avoid being held in state

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "conduktor_password" {
  name  = "/conduktor/password"
  type  = "SecureString"
  value = "CHANGE_ME" # Change in console to avoid being held in state

  lifecycle {
    ignore_changes = [value]
  }
}