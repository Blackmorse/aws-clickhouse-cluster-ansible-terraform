variable "vpc_id" {
  description = "id of vpc"
  type        = string
}

variable "public_key_name" {
  description = "public key for accessing hosts"
  type        = string
}

variable "internet_gateway_id" {
  description = "Internet gateway id"
  type        = string
}
