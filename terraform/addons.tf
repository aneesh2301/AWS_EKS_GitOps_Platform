module "addons" {
  source = "../modules/addons"

  oidc_provider_arn = module.eks.oidc_provider_arn
  tags              = local.common_tags
}

resource "kubernetes_config_map_v1" "flux_substitutions" {
  depends_on = [module.flux_operator_bootstrap]

  metadata {
    name      = "cluster-runtime-values"
    namespace = "tooling"
  }

  data = {
    EBS_CSI_IAM_ROLE_ARN = module.addons.ebs_csi_irsa_role_arn
  }
}