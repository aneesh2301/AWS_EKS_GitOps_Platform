module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.0.3"

  name               = var.cluster_name
  kubernetes_version = var.cluster_version

  # Networking
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # API endpoint access
  endpoint_public_access  = var.cluster_endpoint_public_access
  endpoint_private_access = var.cluster_endpoint_private_access

  # Enable IAM Roles for Service Accounts (IRSA)
  enable_irsa = var.enable_irsa

  # Control plane logging
  enabled_log_types = var.cluster_enabled_log_types

  # EKS managed addons
  addons = var.cluster_addons

  # Managed node group
  eks_managed_node_groups = {
    (var.node_group.name) = {
      instance_types = var.node_group.instance_types
      min_size       = var.node_group.min_size
      max_size       = var.node_group.max_size
      desired_size   = var.node_group.desired_size
      capacity_type  = var.node_group.capacity_type
      subnet_ids     = var.subnet_ids
    }
  }

# Access entries (modern replacement for aws-auth configmap)
  access_entries = {
    cluster_admin = {
      principal_arn = var.admin_principal_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  


  tags = var.tags
}