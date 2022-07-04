locals {
  # Automatically load environment-level variables
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.env_vars.locals.env

  app_name = "${local.env}-apache-asg"
}
dependency "setup" {
  config_path = "${dirname(find_in_parent_folders("region.hcl"))}/setup"
  mock_outputs = {
    vpc_id = "temporary-dummy-id"
    key_name = "temporary_dummy_key"
    public_subnets = ["temporary-dummy-id"]
  }
  mock_outputs_allowed_terraform_commands = ["validate","init"]
}
inputs = {
  # Shared
  subnet_ids = dependency.setup.outputs.public_subnets
  vpc_id     = dependency.setup.outputs.vpc_id

  # ASG
  ami_owner         = "amazon"
  ami_name          = "amzn-ami-hvm*"
  min_size          = "1"
  max_size          = "3"
  ingress_ports      = [22, 80]
  cluster_name      = local.app_name
  health_check_type = "ELB"
  key_name          = dependency.setup.outputs.key_name
  user_data         = <<EOF
    #!/bin/bash
    yum -y install httpd git
    service httpd start
    echo "This is coming from default apache page" >> /var/www/html/index.html
    cd
    git clone https://github.com/PacktPublishing/Mastering-AWS-System-Administration.git
    cd Mastering-AWS-System-Administration/Chapter4-Scalable-compute-capacity-in-the-cloud-via-EC2/html/
    cp -avr work /var/www/html/
  EOF

  # ALB
  alb_name   = local.app_name
  alb_ingress_ports      = [80]
}
