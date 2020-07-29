terraform {
  required_providers {
    aws    = ">= 2.24"
    random = ">= 2.2"
    mysql  = ">= 1.7"
  }
}

terraform {
  experiments = [variable_validation]
}

resource "random_password" "password" {
  count = var.deploy == true ? 1 : 0

  length  = 32
  special = false
}

resource "mysql_user" "user" {
  count = var.deploy == true ? 1 : 0

  user               = var.username
  host               = "%"
  plaintext_password = random_password.password[0].result
}

resource "mysql_grant" "grant" {
  count = var.deploy == true ? length(var.objects) : 0

  user       = mysql_user.user[0].user
  host       = var.host
  database   = split(".", var.objects[count.index])[0]
  table      = split(".", var.objects[count.index])[1]
  privileges = var.grants
}

resource "aws_ssm_parameter" "param" {
  count = (var.deploy == true && var.ssm_prefix != null) ? 1 : 0

  name        = "${var.ssm_prefix}/${mysql_user.user[0].user}/password"
  description = "MySQL password for ${var.username}"
  type        = "String"
  value       = random_password.password[0].result
}
