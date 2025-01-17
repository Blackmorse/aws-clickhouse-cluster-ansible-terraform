terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}



resource "aws_key_pair" "deployer" {
  key_name   = "hetzner-pub"
  public_key = file(var.pub_key_path)
}

module "bastion" {
  source = "./modules/bastion"
  vpc_id = resource.aws_vpc.infra_vpc.id
  public_key_name = aws_key_pair.deployer.key_name
  internet_gateway_id = resource.aws_internet_gateway.internet_gateway.id
}

module "clickhouse" {
  source = "./modules/clickhouse"

  az     = "eu-north-1a"
  cidr   = "10.0.1.0/24"
  vpc_id = aws_vpc.infra_vpc.id

  nat_gateway_id     = module.bastion.nat_gateway_id
  public_subnet_cidr = module.bastion.subnet_cidr
  ami                = module.bastion.ami
  public_key_name    = aws_key_pair.deployer.key_name
}
