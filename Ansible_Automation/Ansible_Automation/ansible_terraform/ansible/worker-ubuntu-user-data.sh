#!/bin/bash
# Prepare Ubuntu worker for Ansible control
apt-get update && apt-get install -y python3 python3-pip
# Enable root SSH
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
