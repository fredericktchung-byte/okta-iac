# =============================================================================
# 🏗️ MAIN CONFIGURATION
# =============================================================================
# This file sets up the Terraform provider configuration for Okta.

terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.6.0" # Compatible with v6.6.1+
    }
  }
}

provider "okta" {
  org_name  = "integrator-1501452"
  base_url  = "okta.com" # Make sure this isn't empty!
  api_token = var.api_token
}