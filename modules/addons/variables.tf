variable "oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the EBS CSI IAM role"
  type        = map(string)
  default     = {}
}