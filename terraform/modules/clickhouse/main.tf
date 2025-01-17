resource "aws_instance" "clickhouse_host" {
  ami = var.ami

  instance_type = "t3.small"
  subnet_id = aws_subnet.clickhouse_subnet.id

  key_name = var.public_key_name
  associate_public_ip_address = false

  vpc_security_group_ids = [ aws_security_group.allow_outbound_and_ssh_from_public_subnet.id ]
  tags = {
    App = "Clickhouse"
    Shard = 1
    Replica = 1
  }
}