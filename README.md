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

Common service definitions are defined in HCL files in "_envcommon"