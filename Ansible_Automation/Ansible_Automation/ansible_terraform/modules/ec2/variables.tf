// EC2 Module - variables.tf

variable "ami" {
  description = "AMI ID for the instance(s)"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to assign"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID to launch instance(s) in"
  type        = string
}

variable "key_name" {
  description = "Key name for SSH access"
  type        = string
}

variable "user_data" {
  description = "User data script to run on launch"
  type        = string
  default     = ""
}

variable "name_prefix" {
  description = "Prefix for Name tag"
  type        = string
  default     = "ec2-instance"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "expose_public" {
  description = "Expose nodes to the internet: true for workers, false for master."
  type        = bool
  default     = true
}
