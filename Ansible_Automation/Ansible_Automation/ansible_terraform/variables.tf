// Root Terraform variables.tf

variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "az" {
  description = "Availability zone"
  type        = string
  default     = "ap-south-1a"
}

variable "env_name" {
  description = "Name for environment/resource naming"
  type        = string
  default     = "ansible-cluster"
}

variable "key_name" {
  description = "Key name for SSH access to EC2 instances"
  type        = string
  default     = "ansible-terraform-key"
}

variable "ubuntu_ami" {
  description = "AMI ID for Ubuntu Server"
  type        = string
  default     = "ami-02d26659fd82cf299"
}

variable "amzn_ami" {
  description = "AMI ID for Amazon Linux"
  type        = string
  default     = "ami-06fa3f12191aa3337"
}

variable "master_type" {
  description = "Instance type for Master node"
  type        = string
  default     = "c7i-flex.large"
}

variable "worker_type" {
  description = "Instance type for Worker nodes"
  type        = string
  default     = "t3.micro"
}

