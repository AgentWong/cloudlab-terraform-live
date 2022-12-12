terraform {
  source = "${include.root.locals.base_source_url}//composite/services/certificate-authority?ref=${include.env.locals.release}"
}
include "root" {
  path   = find_in_parent_folders()
  expose = true
}
include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}
include "certificate-authority" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/certificate-authority.hcl"
}
inputs = {
  # CA
  org_name = upper(include.root.locals.org_name)
  # SM
  path = include.root.locals.relative_path
}