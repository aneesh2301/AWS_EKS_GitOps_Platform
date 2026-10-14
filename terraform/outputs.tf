output "cluster_name" {
  value = module.eks.cluster_id
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider used for IAM Roles for Service Accounts"
  value       = module.eks.oidc_provider_arn
}

output "eks_oidc_issuer_url" {
  description = "HTTPS issuer URL of the EKS OIDC provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "ebs_csi_irsa_role_arn" {
  description = "IAM role ARN assumed by the EBS CSI controller service account"
  value       = module.addons.ebs_csi_irsa_role_arn
}

output "karpenter_controller_irsa_role_arn" {
  description = "IAM role ARN assumed by the Karpenter controller service account"
  value       = module.karpenter.controller_role_arn
}

output "karpenter_node_iam_role_arn" {
  description = "IAM role ARN assigned to Karpenter-provisioned EC2 instances"
  value       = module.karpenter.node_role_arn
}

output "observability_irsa_role_arns" {
  description = "IAM role ARNs for the Mimir, Loki, and Tempo service accounts"
  value       = module.irsa.observability_role_arns
}

output "observability_irsa_role_names" {
  description = "IAM role names for the Mimir, Loki, and Tempo service accounts"
  value       = module.irsa.observability_role_names
}

output "observability_s3_policy_arns" {
  description = "S3 policy ARNs attached to the observability IRSA roles"
  value       = module.irsa.observability_s3_policy_arns
}