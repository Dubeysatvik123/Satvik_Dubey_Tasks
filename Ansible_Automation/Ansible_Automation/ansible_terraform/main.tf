provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
  name               = var.env_name
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ansible" {
  key_name   = "ansible-terraform-key"
  public_key = file("${path.module}/ansible-terraform-key.pub")
}

module "ansible_master" {
  source = "./modules/ec2"
  instance_count = 1
  ami = var.ubuntu_ami
  instance_type = var.master_type
  subnet_id = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  expose_public = true
  key_name = var.key_name
  name_prefix = "ansible-master"
  user_data = file("${path.module}/ansible/master-user-data.sh")
}

module "ansible_worker_ubuntu" {
  source = "./modules/ec2"
  instance_count = 2
  ami = var.ubuntu_ami
  instance_type = var.worker_type
  subnet_id = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  expose_public = true
  key_name = var.key_name
  name_prefix = "ansible-worker-ubuntu"
  user_data = file("${path.module}/ansible/worker-ubuntu-user-data.sh")
}

module "ansible_worker_amzn" {
  source = "./modules/ec2"
  instance_count = 1
  ami = var.amzn_ami
  instance_type = var.worker_type
  subnet_id = module.vpc.public_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  vpc_id = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  expose_public = true
  key_name = var.key_name
  name_prefix = "ansible-worker-amzn"
  user_data = file("${path.module}/ansible/worker-amzn-user-data.sh")
}

