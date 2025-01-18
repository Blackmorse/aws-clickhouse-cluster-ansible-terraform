variable "az" {
  description = "AZ of CH fleet"
  type        = string
}

variable "ami" {
  description = "AMI of ubuntu"
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "public_key_name" {
  description = "public key for accessing hosts"
  type        = string
}

variable "allow_all_outbound_and_inbound_ssh_from_bastion_security_group" {
  type = string
}
