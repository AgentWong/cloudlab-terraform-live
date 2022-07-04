locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region      = local.region_vars.locals.region
  
  org_name        = "valhalla"
  base_source_url = "github.com/AgentWong/cloudlab-terraform-modules"
}

remote_state {
  backend = "s3"
  config = {
    bucket = "${local.org_name}-${local.env}-4ecc"
    key    = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "${local.org_name}-${local.env}"
    encrypt        = true
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  terraform {
        backend "s3" {}
    }
  EOF
}

generate "versions" {
  path = "versions.tf"

  if_exists = "overwrite_terragrunt"

  contents = <<EOF
  terraform { 
    required_version = "~> 1.2.0"
  
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "~> 4.21"
      }
    }
  }
  EOF
}
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
  provider "aws" {
    region = "${local.region}"
  }
  EOF
}

# Prevents excessive .terragrunt-cache size by caching Terraform plugins.
terraform {
  extra_arguments "plugin_dir" {
    commands = [
      "init",
      "plan",
      "apply",
      "destroy",
      "output"
    ]

    env_vars = {
      TF_PLUGIN_CACHE_DIR = "/tmp/plugins",
    }
  }
}