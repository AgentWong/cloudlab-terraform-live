locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region      = local.region_vars.locals.region
}
dependency "active-directory" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/services/active-directory"
  mock_outputs = {
    # Ansible vars
    domain_name        = "contoso.com"
    distinguished_name = "DC=CONTOSO,DC=COM"

    # EC2
    radmin_password_id = "dummy-password"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}
dependency "setup" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/setup"
  mock_outputs = {
    # Ansible vars
    ansible_bastion_private_ip = "temporary-dummy-string"
    linux_bastion_public_dns   = "temporary-dummy-string"
    ec2_keypair_secret_id      = "temporary-dummy-string"

    # EC2
    ansible_winrm_sg_id  = "temporary-dummy-id"
    key_name             = "temporary_dummy_key"
    private_subnets_ids  = ["temporary-dummy-id"]
    private_subnet_cidrs = "8.8.8.8/16"
    vpc_id               = "temporary-dummy-id"
    vpc_cidr             = "10.0"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}
inputs = {
  # Ansible vars
  ansible_bastion_private_ip = dependency.setup.outputs.ansible_bastion_private_ip
  linux_bastion_public_dns   = dependency.setup.outputs.linux_bastion_public_dns
  domain_name                = dependency.active-directory.outputs.domain_name
  distinguished_name         = dependency.active-directory.outputs.distinguished_name
  ec2_keypair_secret_id      = dependency.setup.outputs.ec2_keypair_secret_id

  # EC2
  ansible_winrm_sg_id  = dependency.setup.outputs.winrm_mgmt_sg_id
  environment          = local.env
  key_name             = dependency.setup.outputs.key_name
  private_subnet_cidrs = dependency.setup.outputs.private_subnet_cidr_blocks
  private_subnet_ids   = dependency.setup.outputs.private_subnet_ids
  radmin_password_id   = dependency.active-directory.outputs.radmin_password_id
  region               = local.region
  vpc_id               = dependency.setup.outputs.vpc_id
  vpc_cidr             = dependency.setup.outputs.vpc_cidr
}
