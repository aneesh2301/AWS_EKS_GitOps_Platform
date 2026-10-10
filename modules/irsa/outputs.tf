output "observability_role_arns" {
  description = "IAM role ARNs for the observability service accounts"
  value = {
    for backend, role in aws_iam_role.observability : backend => role.arn
  }
}

output "observability_role_names" {
  description = "IAM role names for the observability service accounts"
  value = {
    for backend, role in aws_iam_role.observability : backend => role.name
  }
}

output "observability_s3_policy_arns" {
  description = "S3 policy ARNs attached to the observability roles"
  value = {
    for backend, policy in aws_iam_policy.observability_s3 : backend => policy.arn
  }
}