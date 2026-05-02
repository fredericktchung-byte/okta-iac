terraform {
  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 6.6.0" # This allows v6.6.1 and above
    }
  }
}

# Configure the Okta Provider
provider "okta" {
  org_name  = var.org_name
  api_token = var.api_token
}