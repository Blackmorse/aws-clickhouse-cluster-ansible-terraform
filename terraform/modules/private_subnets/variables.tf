variable "azs" {
  description = "All AZs for creating private subnets"
  type = list(string)
}

variable "vpc_id" {
  type = string 
}

variable "nat_gateway_id" {
  type = string 
}
