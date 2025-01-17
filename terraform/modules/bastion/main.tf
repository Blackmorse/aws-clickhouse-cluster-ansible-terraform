
data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.ubuntu_ami.image_id

  instance_type = "t3.micro"
  subnet_id     = resource.aws_subnet.bastion_subnet.id

  key_name      = var.public_key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [ resource.aws_security_group.allow_ssh.id ]

  tags = {
    Name = "bastion"
  }
}
