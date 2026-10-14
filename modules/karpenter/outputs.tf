output "controller_role_arn" {
  description = "IAM role ARN assumed by the Karpenter controller through IRSA"
  value       = module.karpenter.iam_role_arn
}

output "node_role_name" {
  description = "IAM role name assigned to Karpenter-provisioned EC2 instances"
  value       = module.karpenter.node_iam_role_name
}

output "node_role_arn" {
  description = "IAM role ARN assigned to Karpenter-provisioned EC2 instances"
  value       = module.karpenter.node_iam_role_arn
}