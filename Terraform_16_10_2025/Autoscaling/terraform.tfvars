# AWS Configuration
aws_region   = "ap-south-1"
project_name = "my-project"
environment  = "dev"

# VPC Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

# ASG Configuration
ami_id               = "ami-06fa3f12191aa3337" # Update with your region's AMI
instance_type        = "t3.micro"
key_name             = "my-keypair" # Update with your key pair
asg_min_size         = 1
asg_max_size         = 3
asg_desired_capacity = 2