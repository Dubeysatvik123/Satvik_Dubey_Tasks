resource "aws_instance" "web" {
  ami           = "ami-0f9708d1cd2cfee41"
  instance_type = var.instance_type
  count = 3
  tags = {
    Name = "WebServer-${count.index + 1}"
  }
}
