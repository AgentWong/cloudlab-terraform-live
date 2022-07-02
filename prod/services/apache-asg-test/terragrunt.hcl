terraform {
  source = "../../../../modules//composite/services/apache-asg-test"
}
include "root" {
  path = find_in_parent_folders()
}
include "region" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}
include "apache-lb-test" {
  path = "${dirname(find_in_parent_folders())}/_env/apache-asg-test.hcl"
  expose = true
}
inputs = {
  instance_type = "t2.micro"
}