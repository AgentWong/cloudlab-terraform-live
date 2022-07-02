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
  region = "us-east-1"
  env    = "dev"
}