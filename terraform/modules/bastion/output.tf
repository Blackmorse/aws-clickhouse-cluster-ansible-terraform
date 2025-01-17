output "bastion_ip" {
  value = resource.aws_instance.bastion_host.public_ip
}

output "subnet_cidr" {
  value = aws_subnet.bastion_subnet.cidr_block
}

output "ami" {
  value = data.aws_ami.ubuntu_ami.image_id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}