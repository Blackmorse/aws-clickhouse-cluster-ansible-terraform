output "az_to_cidr_mapping" {
  value = { for idx, subnet in aws_subnet.az_subnet :
    var.azs[idx] => "10.0.${idx + 1}.0/24" 
  }
}
