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

# These variables are used in identity_providers.tf to configure the OIDC IdP for Auth0.
variable "auth0_domain" {
  type        = string
  description = "The Auth0 tenant domain"
}
# The client ID and secret are used to authenticate Okta with Auth0 for the OIDC IdP configuration.
variable "auth0_client_id" {
  type        = string
  description = "The Client ID from the Auth0 application"
}
# The client secret is marked as sensitive to prevent it from being exposed in logs or state files.
variable "auth0_client_secret" {
  type        = string
  description = "The Client Secret from the Auth0 application"
  sensitive   = true
}

# This variable is used in apps.tf to configure the SAML application for Oracle Cloud Infrastructure (OCI).
variable "oci_domain_id" {
  type        = string
  description = "The unique ID for the OCI Identity Domain (e.g., idcs-123456...)"
}

# Workato JWKS values (these are static since we generated the key pair ourselves and can hardcode them)
variable "workato_jwks_e" {
  type        = string
  description = "Exponent for the Workato RSA key (part of JWKS configuration)"
}
variable "workato_jwks_n" {
  type        = string
  description = "Modulus for the Workato RSA key (part of JWKS configuration)"
}

# Tines JWKS values (these should be generated from the Tines public key)
variable "tines_jwks_e" {
  type        = string
  description = "Exponent for the Tines RSA key (part of JWKS configuration)"
}
variable "tines_jwks_n" {
  type        = string
  description = "Modulus for the Tines RSA key (part of JWKS configuration)"
}