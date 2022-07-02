terraform {
  source = "../../../../modules//composite/services/apache-lb-test"
}
include "root" {
  path = find_in_parent_folders()
}
include "region" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}
include "apache-lb-test" {
  path = "${dirname(find_in_parent_folders())}/_env/apache-lb-test.hcl"
  expose = true
}
inputs = {
  instance_type = "t3.micro"
}