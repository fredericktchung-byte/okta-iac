# =============================================================================
# 📥 INPUT VARIABLES
# =============================================================================
# This file defines input variables used across the Terraform configuration.

variable "org_name" {
  type        = string
  description = "The prefix of your Okta Org URL"
  default     = "integrator-1501452"
}

variable "api_token" {
  type        = string
  description = "Okta API Token"
  sensitive   = true # Keeps token out of console logs
}