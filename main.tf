resource "random_id" "random" {
  byte_length = 2

}

resource "aws_vpc" "ldc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
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
  route_table_id         = aws_route_table.ldc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ldc_gw.id

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
// like for example using data.aws_vailabilty_zones.available.names[0] will use the first zone available

resource "aws_subnet" "ldc_public_subnet" {
  count = length(var.public_cidrs) // This will grab the length of what has been defined in the variables file
  vpc_id                            = aws_vpc.ldc_vpc.id
  cidr_block                        = var.public_cidrs[count.index] // Every time it goes through a count, itll loop through that list and apply that to each variable
  map_public_ip_on_launch = true
  availability_zone                 = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ldc_public-${count.index + 1}"
  }
}

resource "aws_subnet" "ldc_private_subnet" {
  count = length(var.private_cidrs) // This will grab the length of what has been defined in the variables file
  vpc_id                            = aws_vpc.ldc_vpc.id
  cidr_block                        = var.private_cidrs[count.index] // Every time it goes through a count, itll loop through that list and apply that to each variable
  map_public_ip_on_launch = true
  availability_zone                 = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "ldc_private-${count.index + 1}"
  }
}

