module "vpc" {
  source       = "./modules/vpc"
  cidr_block   = "10.0.0.0/16"
  public_subnet= "10.0.1.0/24"
  az           = "us-east-1a"
  name         = "nuxeo-vpc"
}

module "ec2" {
  source           = "./modules/ec2"
  ami              = "ami-0dc2d3e4c0f9ebd18"
  instance_type    = "t3.medium"
  subnet_id        = module.vpc.subnet_id
  vpc_id           = module.vpc.vpc_id
  key_name         = "my-key"
  ssh_user         = "ec2-user"
  private_key_path = "~/.ssh/my-key.pem"
  name             = "nuxeo-ec2"
}

module "cloudwatch" {
  source          = "./modules/cloudwatch"
  log_group_name  = "/nuxeo/app"
  dashboard_name  = "NuxeoDashboard"
  region          = "us-east-1"
  ec2_id          = module.ec2.public_ip
}
