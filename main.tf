resource "random_password" "password" {
  count = var.deploy == true ? 1 : 0

  length = 32
}

resource "mysql_user" "user" {
  count = var.deploy == true ? 1 : 0

  user               = var.username
  host               = "%"
  plaintext_password = random_password.password[0].result
}

resource "mysql_grant" "grant" {
  count = var.deploy == true ? 1 : 0

  user       = mysql_user.user[0].user
  host       = var.host
  database   = var.database
  privileges = var.grants
}

resource "aws_ssm_parameter" "param" {
  count = var.deploy == true ? 1 : 0

  name  = "${var.ssm_prefix}/${mysql_user.user[0].user}/password"
  type  = "String"
  value = random_password.password[0].result
}
