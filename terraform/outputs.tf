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

output "observability_irsa_role_arns" {
  description = "IAM role ARNs for the Mimir, Loki, and Tempo service accounts"
  value = {
    for backend, role in aws_iam_role.observability : backend => role.arn
  }
}

output "observability_irsa_role_names" {
  description = "IAM role names for the Mimir, Loki, and Tempo service accounts"
  value = {
    for backend, role in aws_iam_role.observability : backend => role.name
  }
}

output "observability_s3_policy_arns" {
  description = "S3 policy ARNs attached to the observability IRSA roles"
  value = {
    for backend, policy in aws_iam_policy.observability_s3 : backend => policy.arn
  }
}