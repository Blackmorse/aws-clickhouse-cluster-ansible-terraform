resource "aws_security_group" "allow_outbound_and_ssh_from_public_subnet" {
  name   = "allow_outbound"
  vpc_id = module.vpc.vpc_id

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
  cidr_ipv4         = module.vpc.public_subnets_cidr_blocks[0]
}

resource "aws_instance" "clickhouse_host" {
  for_each = {
    for index, item in flatten([
      for az_index in range(length(var.clickhouse_az)) : [
        for shard in range(var.clickhouse_shards) : {
          shard    = shard
          az_index = az_index
        }
      ]
    ]) : index => item
  }

  ami           = data.aws_ami.ubuntu_ami.image_id
  instance_type = var.ch_instance_type
  subnet_id = module.vpc.private_subnets[
    index(module.vpc.private_subnets_cidr_blocks, local.az_to_cidr[var.clickhouse_az[each.value.az_index]])
  ]

  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = false
  availability_zone           = var.clickhouse_az[each.value.az_index]

  vpc_security_group_ids = [aws_security_group.allow_outbound_and_ssh_from_public_subnet.id]
  tags = {
    Name    = "clickhouse-shard-${each.value.shard}-replica-${each.value.az_index}"
    App     = "Clickhouse"
    Shard   = each.value.shard
    Replica = each.value.az_index
    AZ      = var.clickhouse_az[each.value.az_index]
  }
  lifecycle {
    ignore_changes  = [user_data, ami]
    # prevent_destroy = true
  }
  metadata_options {
    instance_metadata_tags = "enabled"
  } 
}

resource "aws_instance" "zookeeper_host" {
  count = length(var.zookeeper_az)

  ami           = data.aws_ami.ubuntu_ami.image_id
  instance_type = var.zk_instance_type
  subnet_id = module.vpc.private_subnets[
    index(module.vpc.private_subnets_cidr_blocks, local.az_to_cidr[var.zookeeper_az[count.index]])
  ]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = false
  availability_zone           = var.zookeeper_az[count.index]
  vpc_security_group_ids      = [aws_security_group.allow_outbound_and_ssh_from_public_subnet.id]

  tags = {
    Name = "zookeeper-${var.zookeeper_az[count.index]}"
    App  = "Zookeeper"
    AZ   = var.zookeeper_az[count.index]
  }

    lifecycle {
    ignore_changes  = [user_data, ami]
    # prevent_destroy = true
  }

  metadata_options {
    instance_metadata_tags = "enabled"
  } 
}
