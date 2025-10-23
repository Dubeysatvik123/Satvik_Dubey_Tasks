# Ansible Terraform Cluster Solution

This solution deploys a VPC and four EC2 instances (1 Ubuntu master, 2 Ubuntu workers, 1 Amazon Linux worker), using modular Terraform and configures them with Ansible.

## Directory Layout
- `modules/vpc`: Reusable VPC module
- `modules/ec2`: Reusable EC2 module
- `ansible/`: Ansible inventory and playbook files
- `main.tf`, `variables.tf`, `outputs.tf`: Environment orchestrator

## Usage
1. Update `variables.tf` for region, AMIs, key name, etc.
2. Run Terraform to provision infrastructure.
3. Insert output IPs into `ansible/inventory.ini`.
4. Use Ansible to configure the cluster.

See `ansible/README.md` for details on running Ansible.
