resource "aws_subnet" "clickhouse_subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.cidr

  tags = {
    Type = "private"
    App  = "clickhouse"
  }
}


resource "aws_route_table" "clickhouse_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name = "clickhouse-private-route-table-${var.az}"
  }
}

resource "aws_route" "clickhouse_nat_access" {
  route_table_id         = aws_route_table.clickhouse_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_id
}

resource "aws_route_table_association"  "clickhouse_private_subnet_route_table_association" {
  subnet_id      = aws_subnet.clickhouse_subnet.id
  route_table_id = aws_route_table.clickhouse_route_table.id
}
