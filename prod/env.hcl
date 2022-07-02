generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
  }
  EOF
}
locals {
  region = "us-west-2"
  env    = "prod"
}