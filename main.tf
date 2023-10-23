resource "random_id" "random" {
  byte_length = 2

}

resource "aws_vpc" "ldc_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "ldc_vpc-${random_id.random.dec}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "ldc_gw" {
  vpc_id = aws_vpc.ldc_vpc.id

  tags = {
    Name = "ldc_igw-${random_id.random.dec}"
  }

}

resource "aws_route_table" "ldc_public_rt" {
   vpc_id = aws_vpc.ldc_vpc.id
   tags = {
    Name = "ldc-public"
   }
}

resource "aws_route" "default_route" {
  route_table_id = aws_route_table.ldc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ldc_gw.id

}

resource "aws_default_route_table" "ldc_private_route" {
  default_route_table_id = aws_vpc.ldc_vpc.default_route_table_id

  tags = {
    Name = "ldc_private_route"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
} // The reason why we have this added, is because availability zones can change depending on the day and time
// and when we specify the availbility zone in a subnet resource, it could encounter an issue
// so we need to make sure this is dynamically assigned

