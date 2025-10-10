module "vpc" {
  source = "./modules/vpc"

  vpc_cidr    = "10.0.0.0/16"
  subnet_cidr = "10.0.1.0/24"
  vpc_name    = "tf-demo-vpc"
}

module "ec2" {
  source = "./modules/ec2"

  instance_count     = var.instance_count
  subnet_id          = module.vpc.subnet_id
  vpc_id             = module.vpc.vpc_id
  security_group_id  = module.vpc.security_group_id
}
