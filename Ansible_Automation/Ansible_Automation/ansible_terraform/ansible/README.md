# Ansible-Terraform 4-Node Cluster

## Structure
- **modules/vpc**: VPC Terraform module
- **modules/ec2**: EC2 Terraform module
- **ansible**: Ansible playbook and inventory

## To Deploy
1. Ensure your SSH key is present as `ansible-terraform-key.pub` in the root directory.
2. Run Terraform:
   ```bash
   terraform init
   terraform apply -auto-approve
   ```
3. Note the public IPs in the Terraform output, put them into `ansible/inventory.ini`.
4. From within `ansible/`, run:
   ```bash
   ansible-playbook -i inventory.ini site.yml
   ```
---
Adjust the Ansible playbook as needed for your cluster software or tasks.
