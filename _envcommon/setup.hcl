locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env


  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region      = local.region_vars.locals.region
}
inputs = {
  # KMS
  key_name   = "key_to_the_city"
  public_key = get_env("PUBLIC_KEY")
  ec2_private_keymat = get_env("PRIVATE_KEY")

  # VPC
  domain_name = "valhalla.local"
  prefix_name = local.env
  region      = local.region
}