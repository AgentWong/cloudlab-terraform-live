locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.env_vars.locals.env
  region = local.env_vars.locals.region
}
inputs = {
  # KMS
  key_name   = "key_to_the_city"
  public_key = file("~/.ssh/id_rsa.pub")

  # VPC
  prefix_name     = local.env
  region          = local.region
}