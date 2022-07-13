terraform {
  source = "${include.root.locals.base_source_url}//composite/setup?ref=${include.env.locals.release}"
}
include "root" {
  path   = find_in_parent_folders()
  expose = true
}
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}
include "setup" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/setup.hcl"
}
inputs = {
  # VPC
  vpc_cidr        = "172.16.0.0/16"
  tgw_cidr        = "10.0.0.0/16"
  public_subnets  = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
  private_subnets = ["172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24"]

  # Ansible Bastion
  linux_mgmt_cidr = ["${run_cmd("--terragrunt-quiet", "curl", "-s", "https://checkip.amazonaws.com/")}/32"]
}