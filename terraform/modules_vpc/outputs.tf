output "vpc_id" {
  value = module.vpc.vpc_id
}

output "instance_public_ips" {
  value = module.ec2.instance_public_ips
}
