resource "aws_vpc" "infra_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Type = "public"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.infra_vpc.id

  tags = {
    Name = "main_gateway"
  }
}

