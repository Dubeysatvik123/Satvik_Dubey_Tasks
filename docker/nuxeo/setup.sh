#!/bin/bash
sudo -i
apt update -y
apt install -y docker* 
apt install unzip curl
systemctl enable --now docker
docker-compose up -d