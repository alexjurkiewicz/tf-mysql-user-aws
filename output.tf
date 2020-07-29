output "ssm_parameter" {
  description = "Path of the SSM parameter that holds the user password."
  value       = var.deploy == true ? aws_ssm_parameter.param[0].name : null
}

output "password" {
  description = "Generated password for the user."
  value       = random_password.password.result
  sensitive   = true
}
