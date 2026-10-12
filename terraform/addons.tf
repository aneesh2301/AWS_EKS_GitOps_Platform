module "addons" {
  source = "../modules/addons"

  oidc_provider_arn = module.eks.oidc_provider_arn
  tags              = local.common_tags
}