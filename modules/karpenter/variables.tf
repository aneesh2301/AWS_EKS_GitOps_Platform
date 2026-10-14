variable "cluster_name" {
  description = "Name of the EKS cluster"
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

variable "namespace" {
  description = "Kubernetes namespace where the Karpenter controller runs"
  type        = string
  default     = "tooling"
}

variable "service_account" {
  description = "Kubernetes service account used by the Karpenter controller"
  type        = string
  default     = "karpenter"
}

variable "tags" {
  description = "Tags to apply to Karpenter AWS resources"
  type        = map(string)
  default     = {}
}