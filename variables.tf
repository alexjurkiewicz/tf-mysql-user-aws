variable "username" {
  description = "Username to create."
}

variable "objects" {
  description = "Objects (tables) to grant access to."
  default     = ["*.*"]
}

variable "host" {
  description = "Host the user can connect from."
  default     = "%"
}

variable "grants" {
  description = "Privileges to grant for the user."
  default     = ["SELECT"]
}


variable "ssm_prefix" {
  description = <<EOT
    User's password is automatically generated and added to AWS SSM Parameter
    Store with the path "$ssm_prefix/$username/password".
  EOT
  default     = "/db"
}

variable "deploy" {
  default     = true
  description = <<EOT
    Allow conditional deployment of the user. This is useful because Terraform's
    language doesn't natively offer similar functionality.

    Example: deploy an admin user in your test workspace (environment) only:

    ```
    module "dev_admin_access" {
      source   = "github.com/alexjurkiewicz/tf-mysql-user-aws"
      deploy   = terraform.workspace == "test" ? true : false
      username = "admin"
      grants   = ["SELECT", "INSERT", "UPDATE", "DELETE", "ALTER"]
    }
    ```
  EOT
}
