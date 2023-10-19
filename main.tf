resource "aws_vpc" "ldc_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "ldc_vpc"
  }
}

resource "aws_internet_gateway" "ldc_gw" {
  vpc_id = aws_vpc.ldc_vpc.id

  tags = {
    Name = "ldc_igw"
  }

}