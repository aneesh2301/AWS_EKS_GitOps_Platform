variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  type        = string
}

variable "oidc_provider" {
  description = "EKS OIDC issuer host/path without https://"
  type        = string
}

variable "observability_bucket_arn" {
  description = "ARN of the S3 bucket used by observability backends"
  type        = string
}

variable "observability_namespace" {
  description = "Kubernetes namespace containing observability service accounts"
  type        = string
}