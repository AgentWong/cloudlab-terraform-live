locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region      = local.region_vars.locals.region
}
dependency "setup" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/setup"
  mock_outputs = {
    vpc_id                      = "temporary-dummy-id"
    key_name                    = "temporary_dummy_key"
    public_subnets              = ["temporary-dummy-id"]
    private_subnets             = ["temporary-dummy-id"]
    ansible_bastion_private_ips = "temporary-dummy-string"
    linux_bastion_public_dns    = "temporary-dummy-string"
    ec2_keypair_secret_id              = "temporary-dummy-string"
    winrm_mgmt_sg_id            = "temporary-dummy-id"
    private_subnet_cidr_blocks  = "8.8.8.8/16"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}
inputs = {
  # Ansible vars
  ansible_bastion_private_ip = dependency.setup.outputs.ansible_bastion_private_ip
  linux_bastion_public_dns    = dependency.setup.outputs.linux_bastion_public_dns
  domain_name                 = "valhalla.local"
  netbios                     = "VALHALLA"
  ec2_keypair_secret_id              = dependency.setup.outputs.ec2_keypair_secret_id

  # EC2
  ansible_winrm_sg_id  = dependency.setup.outputs.winrm_mgmt_sg_id
  environment          = local.env
  key_name             = dependency.setup.outputs.key_name
  private_subnet_cidrs = dependency.setup.outputs.private_subnet_cidr_blocks
  private_subnet_ids   = dependency.setup.outputs.private_subnet_ids
  public_subnet_cidrs  = dependency.setup.outputs.public_subnet_cidr_blocks
  region               = local.region
  vpc_id               = dependency.setup.outputs.vpc_id

}
