output "ebs_csi_irsa_role_arn" {
  description = "IAM role ARN assumed by the EBS CSI controller service account"
  value       = module.ebs_csi_irsa.arn
}