output "bastion_public_ip" {
  value = module.bastion.bastion_ip
}

output "az_to_subnet_cidr_mapping" {
  value = module.private_subnets.az_to_cidr_mapping
}
