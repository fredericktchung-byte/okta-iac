# =============================================================================
# 📥 INPUT VARIABLES
# =============================================================================
# This file defines input variables used across the Terraform configuration.

variable "org_name" {
  type        = string
  description = "The prefix of your Okta Org URL"
  default     = "integrator-1501452"
}
variable "base_url" {
  type        = string
  description = "The base URL for your Okta Org (e.g., https://dev-123456.okta.com)"
  default     = "okta.com"
}

variable "api_token" {
  type        = string
  description = "Okta API Token"
  sensitive   = true # Keeps token out of console logs
}
