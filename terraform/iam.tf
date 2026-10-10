module "irsa" {
  source = "../modules/irsa"

  cluster_name             = var.cluster_name
  environment              = var.environment
  oidc_provider_arn        = module.eks.oidc_provider_arn
  oidc_provider            = module.eks.oidc_provider
  observability_bucket_arn = aws_s3_bucket.observability.arn
  observability_namespace  = var.observability_namespace
}