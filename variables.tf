# =============================================================================
# 📥 INPUT VARIABLES
# =============================================================================
# This file defines input variables used across the Terraform configuration.

# The organization name is used in the provider configuration to construct the Okta Org URL.
variable "org_name" {
  type        = string
  description = "The prefix of your Okta Org URL"
  default     = "integrator-1501452"
}
# The base URL is used in the provider configuration to specify the Okta Org's API endpoint.
variable "base_url" {
  type        = string
  description = "The base URL for your Okta Org (e.g., https://dev-123456.okta.com)"
  default     = "okta.com"
}
# The API token is required for Terraform to authenticate with the Okta API and manage resources.
variable "api_token" {
  type        = string
  description = "Okta API Token"
  sensitive   = true # Keeps token out of console logs
}

# This variable is used in identity_sources.tf to look up the primary admin user by email.
variable "primary_admin_email" {
  type        = string
  description = "The Okta login/email of the primary administrator running this deployment."
}