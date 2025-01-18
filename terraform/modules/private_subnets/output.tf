output "az_to_cidr_mapping" {
  value = { for idx, subnet in aws_subnet.az_subnet :
    var.azs[idx] => subnet.id
  }
}
