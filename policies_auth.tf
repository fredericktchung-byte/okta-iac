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
# =============================================================================
# IDP ROUTING RULES (Phase 3)
# =============================================================================

# 1. Fetch the default, built-in IdP Discovery Policy
data "okta_policy" "idp_discovery_policy" {
  name = "Idp Discovery Policy"
  type = "IDP_DISCOVERY"
}

# 2. Attach the Rule to the built-in policy
resource "okta_policy_rule_idp_discovery" "auth0_partners" {
  policy_id = data.okta_policy.idp_discovery_policy.id
  name      = "Route @partner.com to Auth0"
  status    = "ACTIVE"

  user_identifier_type = "IDENTIFIER"

  user_identifier_patterns {
    match_type = "SUFFIX"
    value      = "partner.com"
  }

  idp_providers {
    id   = okta_idp_oidc.auth0_ciam.id
    type = "OIDC"
  }
}