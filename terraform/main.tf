terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_key_pair" "deployer" {
  key_name   = "pub_key"
  public_key = var.pub_key
}


locals {
  unique_azs = tolist(toset(concat(var.clickhouse_az, var.zookeeper_az)))
  az_cidr_blocks = [
    for index in range(length(local.unique_azs)) : "10.0.${index + 1}.0/24"
  ]
  az_to_cidr = { for index in range(length(local.unique_azs)) :
    local.unique_azs[index] => local.az_cidr_blocks[index]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "clickhouse-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.unique_azs
  private_subnets = local.az_cidr_blocks
  public_subnets  = ["10.0.0.0/24"]

  create_igw = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
