# =============================================================================
# 🔌 TERRAFORM PROVIDERS
# =============================================================================

terraform {
  # Ensures compatibility across different environments
  required_version = ">= 1.0.0"

  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.10.0"
    }
  }

  # Configures the remote state backend to store Terraform state in Oracle Cloud Infrastructure (OCI)
  backend "oci" {
    bucket    = "okta-iac-terraform-state"
    namespace = "axanshpshsjz"
    region    = "us-sanjose-1"
    key       = "prod/terraform.tfstate"
  }
}

provider "okta" {
  org_name  = var.org_name
  base_url  = var.base_url
  api_token = var.api_token
}
