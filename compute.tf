data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["amazon/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}