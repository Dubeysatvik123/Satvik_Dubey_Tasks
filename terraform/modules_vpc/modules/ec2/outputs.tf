output "instance_ids" {
  value = aws_instance.servers[*].id
}

output "instance_public_ips" {
  value = aws_instance.servers[*].public_ip
}
