variable "instance_count" {}
variable "subnet_id" {}
variable "vpc_id" {}
variable "ami_id" {
  default = "ami-0f9708d1cd2cfee41" 
  }
variable "instance_type" {
  default = "t2.micro"
}
variable "key_name" {
  description = "Existing AWS key pair name"
  default     = "ansible-key"
}
variable "security_group_id" {
  description = "Security group from VPC module"
}
