resource "aws_instance" "zookeeper_host" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.public_key_name
  associate_public_ip_address = false
  availability_zone           = var.az
  vpc_security_group_ids      = [var.allow_all_outbound_and_inbound_ssh_from_bastion_security_group]

  tags = {
    Name = "zookeeper-${var.az}"
	App  = "Zookeeper"
  }
}
