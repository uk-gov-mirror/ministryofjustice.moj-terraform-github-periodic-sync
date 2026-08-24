terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Test harness: consumes the module from a subdirectory so path.module is a
# nested relative path — the same shape real callers get when the module is
# fetched into .terraform/modules/<name>. This is what exercises build.sh the way
# remote consumption does; a root-level plan (path.module == ".") cannot.
# Run `terraform test` from THIS directory.
module "under_test" {
  source = "../.."

  github_organisation   = "acme"
  github_app_secret_arn = "arn:aws:secretsmanager:eu-west-2:123456789012:secret:dummy-AbCdEf"
  cursor_parameter_name = "/dummy/audit_cursor"
  sso_aws_region        = "eu-west-2"
}
