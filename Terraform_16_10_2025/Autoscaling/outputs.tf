
# Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "asg_name" {
  description = "The name of the Auto Scaling Group"
  value       = module.asg.autoscaling_group_name
}

output "asg_arn" {
  description = "The ARN of the Auto Scaling Group"
  value       = module.asg.autoscaling_group_arn
}

output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.asg.launch_template_id
}