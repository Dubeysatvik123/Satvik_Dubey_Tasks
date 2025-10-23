output "instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = [for i in aws_instance.node : i.id]
}

output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = [for i in aws_instance.node : i.public_ip]
}
