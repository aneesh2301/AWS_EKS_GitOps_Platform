# AWS EKS GitOps Platform

This repository contains the current foundation of an AWS-based Kubernetes platform built with Terraform, Amazon EKS, and FluxCD.

At this stage, the repository provisions the core infrastructure, bootstraps GitOps, and deploys a sample microservices application into the cluster.

## What Is Built So Far

- Terraform-based infrastructure provisioning for VPC and EKS
- Reusable Terraform modules for VPC and EKS under [modules/vpc](modules/vpc) and [modules/eks](modules/eks)
- Amazon EKS cluster with managed node groups
- Core EKS addons configured through Terraform
- FluxCD bootstrap for GitOps reconciliation from this repository
- Application deployment manifests under [app/kubernetes](app/kubernetes)
- Flux Kustomization for the dev cluster under [clusters/dev/flux-system](clusters/dev/flux-system)

## Current Architecture

The current flow is:

1. Terraform provisions the VPC and EKS cluster from [terraform](terraform).
2. The EKS module grants cluster admin access to the configured IAM principal.
3. FluxCD watches this Git repository and reconciles the cluster state from [clusters/dev](clusters/dev).
4. Flux deploys the application manifests from [app/kubernetes](app/kubernetes) into the `microservices` namespace.

## Repository Structure

- [terraform](terraform): root Terraform configuration for the environment
- [modules/vpc](modules/vpc): reusable VPC module
- [modules/eks](modules/eks): reusable EKS module
- [remote_backend](remote_backend): backend bootstrap configuration for remote Terraform state
- [clusters/dev/flux-system](clusters/dev/flux-system): Flux bootstrap and app Kustomization for the dev cluster
- [app/kubernetes](app/kubernetes): Kubernetes manifests for the microservices application

## Infrastructure Details

The Terraform configuration currently covers:

- Custom VPC with public and private subnets
- NAT gateway for private subnet egress
- EKS cluster with managed node groups
- Public cluster endpoint access and optional private endpoint support
- IAM access entry for a configured admin principal
- EKS addons:
	- `coredns`
	- `kube-proxy`
	- `vpc-cni`

The VPC subnets are tagged for EKS load balancer and cluster discovery use.

## GitOps Setup

Flux is configured to:

- sync from the `main` branch of this repository
- reconcile the cluster configuration from [clusters/dev](clusters/dev)
- reconcile the application manifests from [app/kubernetes](app/kubernetes)
- deploy the app into the `microservices` namespace

The application Kustomization is defined in [clusters/dev/flux-system/apps.yaml](clusters/dev/flux-system/apps.yaml).

## Sample Application

The repository currently deploys a microservices demo application made up of multiple services, including:

- frontend
- checkoutservice
- cartservice
- productcatalogservice
- paymentservice
- shippingservice
- recommendationservice
- emailservice
- currencyservice
- adservice
- loadgenerator

## How To Use

### 1. Provision infrastructure

From [terraform](terraform):

```zsh
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

### 2. Configure cluster access

After the cluster is created:

```zsh
aws eks update-kubeconfig --name <cluster-name> --region <aws-region>
```

### 3. Verify Flux

```zsh
flux get kustomizations -A
kubectl get pods -n flux-system
```

### 4. Verify the application

```zsh
kubectl get pods -n microservices
kubectl get svc -n microservices
```

## Inputs You Configure

The main environment-specific inputs live in [terraform/terraform.tfvars](terraform/terraform.tfvars), including:

- AWS region
- environment name
- AWS account ID
- VPC CIDR and subnet CIDRs
- cluster name and Kubernetes version
- managed node group sizing
- admin IAM principal ARN for EKS access

## In Progress

The networking layer and platform addons are still in active development.

That work is expected to include broader platform capabilities on top of the current EKS foundation, such as environment hardening, networking extensions, and additional cluster services. The current repository should be treated as the working baseline, not the final platform state.

## Notes

- Terraform state is configured to use an S3 backend.
- Flux is the source of truth for application deployment after cluster bootstrap.
- The current dev environment is the active target under [clusters/dev](clusters/dev).
