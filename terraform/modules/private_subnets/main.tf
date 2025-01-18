resource "aws_subnet" "az_subnet" {
  count = length(var.azs)

  vpc_id = var.vpc_id
  cidr_block = "10.0.${count.index + 1}.0/24"
  availability_zone = var.azs[count.index]
}

resource "aws_route_table" "nat_access" {
  count = length(var.azs)

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.azs[count.index]}-private-route-table"
  }
}

resource "aws_route" "nat_access_route" {
  count = length(var.azs)

  route_table_id = aws_route_table.nat_access[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.nat_gateway_id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  count = length(var.azs)

  subnet_id = aws_subnet.az_subnet[count.index].id
  route_table_id = aws_route_table.nat_access[count.index].id
}
