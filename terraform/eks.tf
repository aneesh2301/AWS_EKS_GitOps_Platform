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