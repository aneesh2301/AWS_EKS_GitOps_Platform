terraform {
  required_version = ">= 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
  }

  # Partial backend config — supply bucket/key/region via backend.hcl.
  # S3 state locking is enabled there with use_lockfile = true.
  # terraform init -backend-config=backend.hcl
  backend "s3" {}
}

# ── AWS Provider ──────────────────────────────────────────────────────────────
provider "aws" {
  region = var.aws_region
}