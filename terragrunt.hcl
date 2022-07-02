remote_state {
  backend = "s3"
  config = {
    bucket = "${local.org_name}-4ecd0687"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-west-2"

    dynamodb_table = "${local.org_name}"
    encrypt        = true
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
  terraform {
        backend "s3" {}
    }
  EOF
}

locals {
  org_name = "valhalla"
}