output "master_public_ip" {
  value = module.ansible_master.public_ips[0]
}

output "worker_ubuntu_public_ips" {
  value = module.ansible_worker_ubuntu.public_ips
}

output "worker_amzn_public_ip" {
  value = module.ansible_worker_amzn.public_ips[0]
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
