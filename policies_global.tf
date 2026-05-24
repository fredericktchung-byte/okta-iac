# =============================================================================
# 🌍 GLOBAL SESSION POLICIES (Phase 2)
# =============================================================================

# Policy: Passwordless & FIDO2
resource "okta_policy_signon" "fastpass" {
  name   = "Passwordless - FastPass & FIDO2"
  status = "ACTIVE"

  # Adopt the live description
  description = "Primary global authentication policy: passwordless-first."

  # Hardcode the existing group ID to prevent detachment
  groups_included = ["00g1100e6nrqyrHst698"]
}

# Rules for Passwordless & FIDO2 Policy
# okta_policy_rule_signon.step_up:
resource "okta_policy_rule_signon" "step_up" {
  access              = "ALLOW"
  authtype            = "ANY"
  identity_provider   = "ANY"
  policy_id           = "00p12lkxrq2RgXCAU698"
  mfa_lifetime        = 0
  mfa_remember_device = false
  mfa_required        = false
  name                = "Step-Up Auth for High Risk Sign-ins"
  network_connection  = "ANYWHERE"
  primary_factor      = "PASSWORD_IDP_ANY_FACTOR"
  priority            = 1
  session_idle        = 720
  session_lifetime    = 720
  session_persistent  = false
  status              = "ACTIVE"
}

# okta_policy_rule_signon.passwordless_all:
resource "okta_policy_rule_signon" "passwordless_all" {
  access              = "ALLOW"
  authtype            = "ANY"
  identity_provider   = "ANY"
  policy_id           = "00p12lkxrq2RgXCAU698"
  mfa_lifetime        = 0
  mfa_remember_device = false
  mfa_required        = false
  name                = "Passwordless - All Users"
  network_connection  = "ANYWHERE"
  primary_factor      = "PASSWORD_IDP_ANY_FACTOR"
  priority            = 2
  session_idle        = 720
  session_lifetime    = 720
  session_persistent  = false
  status              = "ACTIVE"
}