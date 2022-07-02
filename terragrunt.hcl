remote_state {
  backend = "s3"
  config = {
    bucket = "${local.org_name}-${local.env}-${local.region}-4ecd"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "${local.region}"

    dynamodb_table = "${local.org_name}-${local.env}-${local.region}"
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
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.env_vars.locals.env
  region = local.env_vars.locals.region
  org_name = "valhalla"
  base_source_url = "github.com/AgentWong/cloudlab-terraform-modules"
}