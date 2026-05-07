# =============================================================================
# 🔐 AUTHENTICATION POLICIES (Phase 2)
# =============================================================================

# Authenticator Enrollment Policy: Service Accounts
resource "okta_policy_mfa" "service_accounts" {
  name        = "Role - Service Accounts"
  status      = "ACTIVE"
  description = "Modified MFA for service accounts"

  # OIE Flag prevents reversion to Okta Classic
  is_oie = true

  # Hardcoded Okta ID for 'Okta - Role - Service Accounts' to prevent detachment
  groups_included = ["00g11aeo1g4KtFPix698"]
}

# Authenticator Enrollment Policy: Default
resource "okta_policy_mfa" "default" {
  name        = "Default Policy"
  status      = "ACTIVE"
  description = "The default policy applies in all situations if no other policy applies."

  is_oie = true

  groups_included = ["00g1100e6nrqyrHst698"]
}