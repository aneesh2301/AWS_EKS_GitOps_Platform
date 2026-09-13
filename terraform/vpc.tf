locals {
  common_tags = {
    Environment = var.environment
    Account     = var.account_id
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "../modules/vpc"

  name                = var.vpc_name
  cidr                = var.vpc_cidr
  azs                 = var.azs
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }
  enable_nat_gateway  = var.enable_nat_gateway
  single_nat_gateway  = var.single_nat_gateway
  tags                = local.common_tags
}
