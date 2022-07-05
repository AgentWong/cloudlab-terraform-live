locals {
  # Automatically load environment-level variables
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env          = local.env_vars.locals.env

  app_name = "${local.env}-lamp-test"
}
dependency "setup" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/setup"
  mock_outputs = {
    vpc_id         = "temporary-dummy-id"
    key_name       = "temporary_dummy_key"
    public_subnets = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "init"]
}
inputs = {
  # Shared
  subnet_ids   = dependency.setup.outputs.public_subnets
  vpc_id       = dependency.setup.outputs.vpc_id
  service_name = local.app_name

  # ALB
  alb_ingress_ports = [80]

  # ASG
  ami_owner         = "amazon"
  ami_name          = "al2022-ami-2022*5.15*x86_64"
  min_size          = "1"
  max_size          = "3"
  ingress_ports     = [22, 80]
  health_check_type = "ELB"
  key_name          = dependency.setup.outputs.key_name

  # RDS
  private_subnet_ids        = dependency.setup.outputs.private_subnets
}
