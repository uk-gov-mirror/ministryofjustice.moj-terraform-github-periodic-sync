# Credential-free regression test for the Lambda self-build.
#
# mock_provider fakes every AWS call, so no AWS credentials are needed; the
# `external` provider stays real, so `plan` actually runs build.sh. Because this
# harness consumes the module from a parent directory (see ../main.tf),
# path.module is a nested relative path — reproducing the remote-consumption
# behaviour where the build.sh path bug ("No such file or directory") appears.

mock_provider "aws" {
  # IAM + Lambda validate policy JSON / ARNs at plan time, so mocked data sources
  # must return valid-looking values rather than random strings.
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{}"
    }
  }
  mock_data "aws_kms_alias" {
    defaults = {
      target_key_arn = "arn:aws:kms:eu-west-2:123456789012:key/00000000-0000-0000-0000-000000000000"
    }
  }
}

run "build_runs_when_module_is_consumed_from_subdir" {
  command = plan
}
