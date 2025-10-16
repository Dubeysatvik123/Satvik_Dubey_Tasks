terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Security Group for ASG instances
resource "aws_security_group" "asg_sg" {
  name        = "${var.project_name}-asg-sg"
  description = "Security group for ASG instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-asg-sg"
    Environment = var.environment
  }
}

# Auto Scaling Group Module
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 7.0"

  name = "${var.project_name}-asg"

  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  health_check_type   = "EC2"
  vpc_zone_identifier = module.vpc.private_subnets

  # Launch template
  launch_template_name        = "${var.project_name}-lt"
  launch_template_description = "Launch template for ${var.project_name}"
  update_default_version      = true

  image_id          = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  ebs_optimized     = true
  enable_monitoring = true

  # IAM instance profile
  create_iam_instance_profile = true
  iam_role_name               = "${var.project_name}-asg-role"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for ASG instances"
  iam_role_tags = {
    Name = "${var.project_name}-asg-role"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  # Security groups
  security_groups = [aws_security_group.asg_sg.id]

  # User data
  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    project_name = var.project_name
  }))

  # Block device mappings
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size           = 20
        volume_type           = "gp3"
        delete_on_termination = true
        encrypted             = true
      }
    }
  ]

  # Scaling policies
  scaling_policies = {
    cpu-scale-up = {
      policy_type               = "TargetTrackingScaling"
      estimated_instance_warmup = 300
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 70.0
      }
    }
  }

  # Tags
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
