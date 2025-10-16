# Security Group
resource "aws_security_group" "asg_sg" {
  name        = "${var.project_name}-asg-sg"
  description = "Security group for ASG instances"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
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

# ASG
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 7.0"

  name = "${var.project_name}-asg"

  min_size            = var.asg_min_size
  max_size            = var.asg_max_size
  desired_capacity    = var.asg_desired_capacity
  health_check_type   = "EC2"
  vpc_zone_identifier = var.private_subnets

  launch_template_name        = "${var.project_name}-lt"
  launch_template_description = "Launch template for ${var.project_name}"
  update_default_version      = true

  image_id          = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  ebs_optimized     = true
  enable_monitoring = true

  create_iam_instance_profile = true
  iam_role_name               = "${var.project_name}-asg-role"
  iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role for ASG instances"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  security_groups = [aws_security_group.asg_sg.id]

  user_data = base64encode(templatefile(var.user_data_path, {
    project_name = var.project_name
  }))

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

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
