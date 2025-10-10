resource "aws_instance" "servers" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name      = var.key_name

  tags = {
    Name = "tf-instance-${count.index + 1}"
  }
}
