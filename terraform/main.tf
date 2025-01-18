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
  source              = "./modules/bastion"
  vpc_id              = resource.aws_vpc.infra_vpc.id
  public_key_name     = aws_key_pair.deployer.key_name
  internet_gateway_id = resource.aws_internet_gateway.internet_gateway.id
}

module "private_subnets" {
  source = "./modules/private_subnets"

  azs            = tolist(toset(concat(var.clickhouse_az, var.zookeeper_az)))
  nat_gateway_id = module.bastion.nat_gateway_id
  vpc_id         = aws_vpc.infra_vpc.id
}

module "clickhouse" {
  count = length(var.clickhouse_az)

  source = "./modules/clickhouse"
  az     = var.clickhouse_az[count.index]

  subnet_id       = module.private_subnets.az_to_cidr_mapping[var.clickhouse_az[count.index]]
  shards          = 2
  public_key_name = aws_key_pair.deployer.key_name
  replica_num     = var.clickhouse_shards
  ami             = module.bastion.ami
  instance_type   = "t3.small"

  allow_all_outbound_and_inbound_ssh_from_bastion_security_group = aws_security_group.allow_outbound_and_ssh_from_public_subnet.id
}

module "zookeeper" {
  count = length(var.zookeeper_az)

  source = "./modules/zookeeper"
  az     = var.zookeeper_az[count.index]

  subnet_id       = module.private_subnets.az_to_cidr_mapping[var.zookeeper_az[count.index]]
  public_key_name = aws_key_pair.deployer.key_name
  ami             = module.bastion.ami
  instance_type   = "t3.small"

  allow_all_outbound_and_inbound_ssh_from_bastion_security_group = aws_security_group.allow_outbound_and_ssh_from_public_subnet.id
}
