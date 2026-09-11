locals {
  common_tags = {
    Project     = var.project
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

module "eks" {
  source = "../modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Networking — wired from VPC module outputs
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  cluster_endpoint_private_access = var.cluster_endpoint_private_access

  enable_irsa               = var.enable_irsa
  cluster_enabled_log_types = var.cluster_enabled_log_types
  cluster_addons            = var.cluster_addons
  node_group                = var.node_group
  admin_principal_arn       = var.admin_principal_arn

  tags = local.common_tags
}