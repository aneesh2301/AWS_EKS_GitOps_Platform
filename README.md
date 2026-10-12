# AWS EKS GitOps Platform

An AWS Kubernetes platform built with Terraform, Amazon EKS, Flux Operator, and Flux CD. Terraform owns cloud infrastructure and bootstrap resources; Flux reconciles platform services and applications from this repository.

## Current Status

### Configured

- VPC with public and private subnets, NAT gateway options, and EKS subnet tags.
- EKS cluster with managed node groups, core addons, IRSA, control-plane logs, and an EKS access entry for the configured administrator.
- Terraform remote-state backend configuration under [terraform](terraform) and bootstrap configuration under [remote_backend](remote_backend).
- Flux Operator bootstrap in the `tooling` namespace, synchronized from `main` at [clusters/dev/tooling](clusters/dev/tooling).
- Git credentials read from AWS Secrets Manager at `secret/flux/dev/git-credentials`.
- Observability S3 bucket plus IRSA roles for Mimir, Loki, and Tempo.
- EBS CSI controller IRSA role. Terraform publishes its ARN to the `tooling/cluster-runtime-values` ConfigMap; Flux substitutes it into the EBS CSI HelmRelease.
- GitOps definitions for the microservices app, Sealed Secrets, Prometheus Operator CRDs, kube-prometheus-stack, Kyverno, Mimir, and the AWS EBS CSI driver.

### Needs Cluster Reconciliation

The repository has been locally validated, but runtime health must be checked after applying Terraform and allowing Flux to reconcile. In particular:

- Mimir has a Flux Kustomization but [infrastructure/monitoring/mimir](infrastructure/monitoring/mimir) still needs a `kustomization.yaml` that includes its HelmRepository and HelmRelease, and its `values.yaml` must be connected to the HelmRelease.
- Confirm Flux source authentication, HelmRepository readiness, HelmRelease readiness, and workload health on the cluster.
- Confirm the desired Kyverno CRD ownership approach before relying on Kyverno policies in production.

## Architecture

```text
Terraform
	-> VPC, EKS, OIDC provider, S3, IAM/IRSA, Flux bootstrap
	-> FluxInstance in tooling
	-> GitRepository: clusters/dev/tooling
	-> Flux Kustomizations
			 -> monitoring-crds -> mimir -> monitoring
			 -> ebs-csi-driver (IRSA ARN injected from ConfigMap)
			 -> kyverno
			 -> sealed-secrets
			 -> apps -> app/kubernetes
```

## Repository Layout

- [terraform](terraform): environment Terraform root, including Flux bootstrap, S3, IRSA, and EBS CSI IAM integration.
- [modules/vpc](modules/vpc): reusable VPC module.
- [modules/eks](modules/eks): reusable EKS module.
- [modules/irsa](modules/irsa): observability IRSA roles and scoped S3 policies.
- [modules/addons](modules/addons): EBS CSI controller IRSA role.
- [clusters/dev/tooling](clusters/dev/tooling): Flux root and cluster-level reconciliation order.
- [infrastructure/monitoring](infrastructure/monitoring): Prometheus stack, CRDs, and Mimir configuration.
- [infrastructure/networking/ebs-csi-driver](infrastructure/networking/ebs-csi-driver): AWS EBS CSI Helm release.
- [infrastructure/kyverno](infrastructure/kyverno): Kyverno manifests.
- [app/kubernetes](app/kubernetes): microservices application manifests.

## Provisioning

From [terraform](terraform):

```zsh
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

Terraform requires an AWS Secrets Manager secret named `secret/flux/dev/git-credentials`. It may contain either a JSON value with `username` and `password` fields or a token string; the credential must be authorized to read this repository.

After the cluster is available:

```zsh
aws eks update-kubeconfig --name eks-dev-cluster --region us-east-1
```

## Verification

```zsh
kubectl get fluxinstances -n tooling
kubectl get gitrepositories,kustomizations,helmreleases -A
kubectl get pods -n tooling
kubectl get pods -n monitoring
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
kubectl get pods -n microservices
```

Inspect a failed reconciliation with:

```zsh
kubectl describe kustomization <name> -n tooling
kubectl describe helmrelease <name> -n <namespace>
```

## Terraform Outputs

Terraform exports cluster access and integration values, including:

- `eks_oidc_provider_arn`
- `eks_oidc_issuer_url`
- `ebs_csi_irsa_role_arn`
- `observability_irsa_role_arns`
- `observability_s3_policy_arns`

## Local Validation

```zsh
terraform -chdir=terraform validate
kubectl kustomize clusters/dev/tooling
kubectl kustomize infrastructure/networking/ebs-csi-driver
```
