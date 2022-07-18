# Cloudlab Terraform Live
This space is for Terragrunt to run Terraform modules hosted in a separate repository.  
https://github.com/AgentWong/cloudlab-terraform-modules

The overall structure closely reflects the Gruntworks Terragrunt live infrastructure in design:  
https://github.com/gruntwork-io/terragrunt-infrastructure-live-example

## Structure
```
.
├── LICENSE
├── README.md
├── _envcommon
│   ├── active-directory.hcl
│   ├── apache-asg-test.hcl
│   ├── apache-lb-test.hcl
│   ├── hello-world-app.hcl
│   ├── lamp-test.hcl
│   └── setup.hcl
├── dev
│   ├── env.hcl
│   └── us-east-1
│       ├── region.hcl
│       ├── services
│       │   ├── active-directory
│       │   │   └── terragrunt.hcl
│       │   ├── apache-lb-test
│       │   │   └── terragrunt.hcl
│       │   ├── hello-world-app
│       │   │   └── terragrunt.hcl
│       │   └── lamp-test
│       │       └── terragrunt.hcl
│       └── setup
│           └── terragrunt.hcl
├── prod
│   ├── env.hcl
│   └── us-west-2
│       ├── region.hcl
│       ├── services
│       │   └── apache-lb-test
│       │       └── terragrunt.hcl
│       └── setup
│           └── terragrunt.hcl
└── terragrunt.hcl
```

Common service definitions for all environments are defined in HCL files in "_envcommon"

Example of setup.hcl:  
```
locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env


  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region      = local.region_vars.locals.region
}
inputs = {
  # KMS
  key_name   = "key_to_the_city"
  public_key = file("~/.ssh/id_rsa.pub")

  # VPC
  domain_name = "valhalla.local"
  prefix_name = local.env
  region      = local.region
}
```

Variables that are different between environments can be specified in the respective child terragrunt.hcl files.

Example of dev/us-east-1/setup/terragrunt.hcl:  
```
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
```

  
Example of prod/us-west-2/setup/terragrunt.hcl:  
```
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
  vpc_cidr        = "10.0.0.0/16"
  tgw_cidr        = "172.16.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
```

Because of the structure, if you use "terragrunt run-all apply" from the "dev" and "prod" folders to deploy the code, the folder and file structure very accurately represents what your actual deployed resources will look like.