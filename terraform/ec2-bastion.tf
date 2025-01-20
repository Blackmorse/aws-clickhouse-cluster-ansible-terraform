resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_bastion" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6_bastion" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_bastion" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.ubuntu_ami.image_id

  instance_type = "t3.micro"
  subnet_id     = module.vpc.public_subnets[0]

  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "bastion"
  }
}

