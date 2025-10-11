#!/bin/bash
set -e


echo "[INFO] Updating system and installing Docker..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [[ "$ID" == "amzn" || "$ID_LIKE" == *"amazon"* ]]; then
        amazon-linux-extras install docker -y
        yum install -y git curl
    else
        apt-get update
        apt-get install -y docker.io docker-compose git curl
    fi
fi

systemctl enable docker
systemctl start docker
usermod -aG docker ec2-user


DOCKER_COMPOSE_VERSION="2.20.2"
if ! command -v docker-compose &> /dev/null; then
    echo "[INFO] Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi


NUXEO_DIR="/home/ec2-user/nuxeo"
if [ ! -d "$NUXEO_DIR" ]; then
    echo "[INFO] Cloning Nuxeo repository..."
    git clone https://github.com/Dubeysatvik123/Satvik_Dubey_Tasks.git "$NUXEO_DIR"
fi

cd "$NUXEO_DIR/docker/nuxeo"


echo "[INFO] Deploying Nuxeo cluster using Docker Compose..."
docker-compose up -d


echo "[INFO] Installing and configuring CloudWatch Agent..."
yum install -y amazon-cloudwatch-agent || apt-get install -y amazon-cloudwatch-agent

cat > /opt/aws/amazon-cloudwatch-agent/bin/config.json <<EOL
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/home/ec2-user/nuxeo/docker/nuxeo/logs/nuxeo.log",
            "log_group_name": "/nuxeo/app",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOL


/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s

echo "[INFO] Nuxeo deployment complete!"
