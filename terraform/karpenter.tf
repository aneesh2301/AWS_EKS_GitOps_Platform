module "karpenter" {
  source = "../modules/karpenter"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider     = module.eks.oidc_provider
  namespace         = "tooling"
  tags              = local.common_tags
}

resource "aws_ec2_tag" "karpenter_node_security_group_discovery" {
  resource_id = module.eks.node_security_group_id
  key         = "karpenter.sh/discovery"
  value       = module.eks.cluster_name
}

resource "kubernetes_config_map_v1" "karpenter_runtime_values" {
  depends_on = [module.flux_operator_bootstrap]

  metadata {
    name      = "karpenter-runtime-values"
    namespace = "tooling"
  }

  data = {
    KARPENTER_CONTROLLER_ROLE_ARN = module.karpenter.controller_role_arn
    KARPENTER_NODE_ROLE_NAME      = module.karpenter.node_role_name
  }
}