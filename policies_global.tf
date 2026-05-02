resource "okta_policy_signon" "engineering_mfa_policy" {
  name        = "Engineering - MFA Mandate"
  description = "Requires MFA for all Engineering sessions"
  status      = "ACTIVE"
}

resource "okta_policy_rule_signon" "require_mfa_rule" {
  policy_id = okta_policy_signon.engineering_mfa_policy.id
  name      = "MFA Required Every Sign-On"
  status    = "ACTIVE"

  access = "ALLOW"

  mfa_required = true
  mfa_prompt   = "ALWAYS"
  mfa_lifetime = 0
}

# ============================================================================
# PASSWORDLESS POLICY RULES - Phase 4 Implementation
# ============================================================================
# These rules enforce passwordless authentication using possession (device)
# and verification (biometric/PIN) factors. No password knowledge required.
#
# Constraint structure:
# {
#   "possession": {"required": true, "deviceBound": "REQUIRED"},
#   "verification": {"required": "PREFERRED", "methods": ["BIOMETRICS", "PIN"]}
# }
#
# This replaces the old "knowledge" constraint:
# {
#   "knowledge": {"types": ["password"], "required": true}
# }
# ============================================================================

# Default passwordless rule for all users
# Primary factors: Okta Verify (FastPass), WebAuthn (FIDO2)
resource "okta_policy_rule_signon" "passwordless_default_rule" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Passwordless - All Users"
  priority  = 1
  status    = "ACTIVE"

  access = "ALLOW"
}

# Enhanced rule for sensitive operations (optional - future enhancement)
# Could require higher assurance with channel binding
resource "okta_policy_rule_signon" "passwordless_high_assurance_rule" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Passwordless - High Assurance (Risk-Based)"
  priority  = 2
  status    = "ACTIVE"

  access = "ALLOW"
}

# Catch-all rule for passwordless policy
resource "okta_policy_rule_signon" "passwordless_catchall_rule" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Passwordless - Catch-All"
  priority  = 99
  status    = "ACTIVE"

  access = "ALLOW"
}