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
  region = "us-east-1"
  env    = "dev"
  release = "v0.3.6"
}