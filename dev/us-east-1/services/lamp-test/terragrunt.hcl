terraform {
  source = "${include.root.locals.base_source_url}//composite/services/lamp-test?ref=${include.env.locals.release}"
}
include "root" {
  path   = find_in_parent_folders()
  expose = true
}
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}
include "apache-lb-test" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/lamp-test.hcl"
}
inputs = {
  # ASG
  instance_type = "t2.micro"
  linux_mgmt_cidr   = ["${run_cmd("--terragrunt-quiet", "curl", "-s", "https://checkip.amazonaws.com/")}/32"]

  # SM
  path = include.root.locals.relative_path
}