#!/bin/bash
apt update -y
apt install -y nginx
systemctl enable nginx
systemctl start nginx
echo "<h1>${project_name} - ASG instance</h1>" > /var/www/html/index.html
