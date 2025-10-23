variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "name" {
  description = "Name tag for all resources"
  type        = string
}

variable "az" {
  description = "Availability zone"
  type        = string
}
