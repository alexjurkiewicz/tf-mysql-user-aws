output "ssm_parameter" {
  description = "Path of the SSM parameter that holds the user password."
  value       = aws_ssm_parameter.param[0].name
}
