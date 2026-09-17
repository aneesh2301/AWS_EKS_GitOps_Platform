aws_region  = "us-east-1"
environment = "dev"
account_id  = "339712970776"


# ── VPC ───────────────────────────────────────────────────────────────────────
vpc_name           = "eks-vpc"
vpc_cidr           = "10.0.0.0/16"
azs                = ["us-east-1a", "us-east-1b"]
private_subnets    = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
enable_nat_gateway = true
single_nat_gateway = true

# ── EKS ───────────────────────────────────────────────────────────────────────
cluster_name                    = "eks-dev-cluster"
cluster_version                 = "1.34"
cluster_endpoint_public_access  = false
cluster_endpoint_private_access = true
enable_irsa                     = true

node_group = {
  name           = "dev-nodes"
  instance_types = ["t3.medium"]
  min_size       = 1
  max_size       = 3
  desired_size   = 3
  capacity_type  = "ON_DEMAND"
}

admin_principal_arn = "arn:aws:iam::339712970776:role/cluster_role"