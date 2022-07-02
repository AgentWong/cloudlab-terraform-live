terraform {
  source = "../../../modules//composite/setup"
}
include "root" {
  path = find_in_parent_folders()
}
include "region" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}
include "setup" {
  path = "${dirname(find_in_parent_folders())}/_env/setup.hcl"
  expose = true
}
inputs = {
  # VPC
  vpc_cidr        = "10.0.0.0/16"
  tgw_cidr        = "10.0.0.0/8"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}