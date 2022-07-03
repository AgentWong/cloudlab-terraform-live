generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
  }
  EOF
}
locals {
  region = "us-west-2"
  env    = "prod"
  release = "v0.3.6"
}