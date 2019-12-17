# tf-mysql-user-aws

This module creates a MySQL user account and publishes the password as an AWS SSM Parameter Store item.

Use this to manage the accounts of real people in a RDS MySQL / Aurora database.

Don't use this to manage application accounts.

## Usage

Load the `mysql`, `aws`, and `random` providers, then source this repository. You can check the [releases page](https://github.com/alexjurkiewicz/tf-mysql-user-aws/releases) to find the most recent version.

The only required variable is `username`. Read `variables.tf` for documentation on all variables.

```terraform
  # Required modules
  provider "mysql" {}
  provider "aws" {}
  provider "random" {}

  # Create read-only user
  module "alexj_readonly" {
    source   = "github.com/alexjurkiewicz/tf-mysql-user-aws?ref=xxx"
    username = "alexj_readonly"
  }
  # Create admin user in test only
  module "admin_test" {
    source   = "github.com/alexjurkiewicz/tf-mysql-user-aws?ref=xxx"
    username = "admin"
    grants   = ["SELECT", "INSERT", "UPDATE", "DELETE", "ALTER"]
    deploy   = terraform.workspace == "test" ? true : false
  }
  # Give access to certain tables only
  module "product1_readonly" {
    source   = "github.com/alexjurkiewicz/tf-mysql-user-aws?ref=xxx"
    username = "product1"
    objects  = ["product1.*", "master.product1"]
  }
```

## FAQ

**Q: Why not use [IAM Authentication](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Connecting.AWSCLI.html)?**

* A: IAM Authentication is technically challenging. Users need an IAM account and to run a command-line tool.

**Q: Why not use [AWS Secrets Manager](https://aws.amazon.com/secrets-manager/)?**

* A: Secrets Manager is great if you want automatic credential rotation. But we don't.

**Q: Why isn't this module good for managing application accounts?**

* A: Application account passwords should rotate frequently and have defined access policies. IAM Authentication or Secrets Manager are much better fits.
