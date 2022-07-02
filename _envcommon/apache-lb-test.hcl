locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env      = local.env_vars.locals.env
  app_name = "${local.env}-apache"
}
dependency "setup" {
  config_path = "${get_terragrunt_dir()}/../../setup"
}
inputs = {
  # Shared
  ingress_ports = [22, 80]
  vpc_id        = dependency.setup.outputs.vpc_id

  # EC2
  ami_owner      = "amazon"
  ami_name       = "amzn-ami-hvm*"
  instance_count = "2"
  instance_name  = local.app_name

  key_name  = dependency.setup.outputs.key_name
  user_data = <<EOF
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
  subnet1_id = dependency.setup.outputs.public_subnets[0]
  subnet2_id = dependency.setup.outputs.public_subnets[1]

}
