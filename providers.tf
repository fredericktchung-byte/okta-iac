# =============================================================================
# 🔌 TERRAFORM PROVIDERS
# =============================================================================

terraform {
  # Ensures compatibility across different environments
  required_version = ">= 1.0.0"

  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.6.0" 
    }
  }
}

provider "okta" {
  org_name  = var.org_name
  base_url  = var.base_url
  api_token = var.api_token
}