resource "aws_subnet" "bastion_subnet" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.0.0/24"

  tags = {
    Type = "public"
    Name = "bastion"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.bastion_subnet.id

  tags = {
    Name = "nat-gateway"
  }
}

resource "aws_route_table" "bastion_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "my-public-route-table"
  }
}

resource "aws_route" "bastion_internet_access" {
  route_table_id         = aws_route_table.bastion_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

resource "aws_route_table_association" "bastion_subnet_route_table_association" {
  subnet_id      = aws_subnet.bastion_subnet.id
  route_table_id = aws_route_table.bastion_route_table.id
}