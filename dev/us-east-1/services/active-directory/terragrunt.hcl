terraform {
  source = "${include.root.locals.base_source_url}//composite/services/active-directory?ref=${include.env.locals.release}"
}
include "root" {
  path   = find_in_parent_folders()
  expose = true
}
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}
include "active-directory" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/active-directory.hcl"
}
inputs = {
  # SM
  path = include.root.locals.relative_path
}