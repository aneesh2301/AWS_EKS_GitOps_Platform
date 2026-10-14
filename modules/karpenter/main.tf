data "aws_iam_policy_document" "controller_irsa_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account}"]
    }
  }
}

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "21.0.3"

  cluster_name = var.cluster_name

  namespace       = var.namespace
  service_account = var.service_account

  enable_spot_termination             = false
  create_pod_identity_association      = false
  iam_role_name                        = "KarpenterControllerRole"
  iam_role_use_name_prefix             = false
  iam_policy_name                      = "KarpenterControllerPolicy-${var.cluster_name}"
  iam_policy_use_name_prefix           = false
  iam_role_source_assume_policy_documents = [
    data.aws_iam_policy_document.controller_irsa_assume_role.json,
  ]

  node_iam_role_name            = "KarpenterNodeRole-${var.cluster_name}"
  node_iam_role_use_name_prefix = false
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags
}