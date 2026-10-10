output "cluster_id" {
  description = "The ID/name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "The API server endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate data required to connect to the EKS API server"
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider used for IAM Roles for Service Accounts"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  description = "EKS OIDC issuer host/path without https://"
  value       = module.eks.oidc_provider
}

output "cluster_oidc_issuer_url" {
  description = "HTTPS issuer URL of the EKS OIDC provider"
  value       = module.eks.cluster_oidc_issuer_url
}