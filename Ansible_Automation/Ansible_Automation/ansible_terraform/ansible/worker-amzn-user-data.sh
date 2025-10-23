#!/bin/bash
# Prepare Amazon Linux worker for Ansible
yum update -y
yum install -y python3
# Enable root SSH
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
