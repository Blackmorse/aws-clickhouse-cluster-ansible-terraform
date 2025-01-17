variable "az" {
  description = "AZ of CH fleet"
  type        = string
}

variable "cidr" {
  description = "Desired CIDR of the new subnet"
  type        = string
}

variable "vpc_id" {
  description = "id of vpc"
  type        = string
}

variable "nat_gateway_id" {
  description = "ID of the NAT gateway in the public subnet"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR of public subnet"
  type        = string
}

variable "ami" {
  description = "AMI of ubuntu"
  type        = string
}

variable "public_key_name" {
  description = "public key for accessing hosts"
  type        = string
}