terraform {
  source = "${include.root.locals.base_source_url}//composite/services/apache-asg-test?ref=${include.env.locals.release}"
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
  path = "${dirname(find_in_parent_folders())}/_envcommon/apache-asg-test.hcl"
}
inputs = {
  instance_type = "t2.micro"
}