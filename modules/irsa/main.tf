locals {
	observability_backends = {
		mimir = {
			prefixes        = ["blocks", "alertmanager", "ruler"]
			service_account = "mimir"
		}
		loki = {
			prefixes        = ["logs"]
			service_account = "loki"
		}
		tempo = {
			prefixes        = ["traces"]
			service_account = "tempo"
		}
	}
}

resource "aws_iam_role" "observability" {
	for_each = local.observability_backends

	name = "${var.cluster_name}-${var.environment}-${each.key}-s3"

	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [{
			Effect = "Allow"
			Principal = {
				Federated = var.oidc_provider_arn
			}
			Action = "sts:AssumeRoleWithWebIdentity"
			Condition = {
				StringEquals = {
					"${var.oidc_provider}:aud" = "sts.amazonaws.com"
					"${var.oidc_provider}:sub" = "system:serviceaccount:${var.observability_namespace}:${each.value.service_account}"
				}
			}
		}]
	})

	tags = {
		ManagedBy = "terraform"
		Purpose   = "observability"
	}
}

resource "aws_iam_policy" "observability_s3" {
	for_each = local.observability_backends

	name = "${var.cluster_name}-${var.environment}-${each.key}-s3"

	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Sid    = "DescribeAndListBucket"
				Effect = "Allow"
				Action = [
					"s3:GetBucketLocation",
					"s3:ListBucket",
					"s3:ListBucketMultipartUploads"
				]
				Resource = var.observability_bucket_arn
			},
			{
				Sid    = "ManageOwnObjects"
				Effect = "Allow"
				Action = [
					"s3:GetObject",
					"s3:PutObject",
					"s3:DeleteObject",
					"s3:AbortMultipartUpload",
					"s3:ListMultipartUploadParts"
				]
				Resource = [
					for prefix in each.value.prefixes : "${var.observability_bucket_arn}/${prefix}/*"
				]
			}
		]
	})
}

resource "aws_iam_role_policy_attachment" "observability_s3" {
	for_each = local.observability_backends

	role       = aws_iam_role.observability[each.key].name
	policy_arn = aws_iam_policy.observability_s3[each.key].arn
}
