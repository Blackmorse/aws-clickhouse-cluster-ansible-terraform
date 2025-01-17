resource "aws_security_group" "allow_outbound_and_ssh_from_public_subnet" {
  name = "allow_outbound"
  vpc_id = var.vpc_id

  tags = {
    Name = "Allow outbound"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_outbound_and_ssh_from_public_subnet.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_outbound_and_ssh_from_public_subnet.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_outbound_and_ssh_from_public_subnet.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.public_subnet_cidr
}