locals {
  flux_git_credentials_secret_id = "secret/flux/${var.environment}/git-credentials"
  flux_git_credentials           = try(jsondecode(data.aws_secretsmanager_secret_version.git_credentials.secret_string), null)
  flux_git_username              = try(local.flux_git_credentials.username, "git")
  flux_git_password              = try(local.flux_git_credentials.password, data.aws_secretsmanager_secret_version.git_credentials.secret_string)
}

data "aws_secretsmanager_secret_version" "git_credentials" {
  secret_id = local.flux_git_credentials_secret_id
}

module "flux_operator_bootstrap" {
  depends_on = [module.eks]
  source   = "controlplaneio-fluxcd/flux-operator-bootstrap/kubernetes"
  version    = "0.8.0"
  revision = 1

  gitops_resources = {
    instance_yaml = file("${path.root}/../clusters/${var.environment}/tooling/flux-instance.yaml")
  }

  managed_resources = {
    secrets_yaml = <<-YAML
      apiVersion: v1
      kind: Secret
      metadata:
        name: git-credentials
      type: Opaque
      stringData:
        username: '${replace(local.flux_git_username, "'", "''")}'
        password: '${replace(local.flux_git_password, "'", "''")}'
    YAML
  }
}