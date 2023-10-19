resource "aws_vpc" "ldc_vpc" {
  cidr_block = var.dev_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "ldc_vpc"
  }
}