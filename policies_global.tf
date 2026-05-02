# ============================================================================
# 📁 GLOBAL POLICY: PASSWORDLESS AUTHENTICATION
# ============================================================================

resource "okta_policy_signon" "passwordless" {
  name            = "Passwordless - FastPass & FIDO2"
  description     = "Primary global authentication policy: passwordless-first."
  status          = "ACTIVE"
  priority        = 1
  groups_included = [data.okta_everyone_group.everyone.id]
}

# ============================================================================
# 🛡️ PASSWORDLESS RULES (Evaluated Top-Down)
# ============================================================================

# Priority 1: The Hard Boundary
resource "okta_policy_rule_signon" "block_proxies_allow_icloud" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Block Detected Proxies & VPNs (Allow iCloud)"
  status    = "ACTIVE"
  priority  = 1

  # FLATTENED NETWORK CONDITIONS
  network_connection = "ZONE"
  network_includes   = [okta_network_zone.proxy_check.id]

  access = "DENY"
}

# Priority 2: The Adaptive "Risk" Bouncer
resource "okta_policy_rule_signon" "passwordless_high_risk" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Step-Up Auth for High Risk Sign-ins"
  status    = "ACTIVE"
  priority  = 2

  # FLATTENED RISK CONDITION
  risk_level = "HIGH"

  access = "ALLOW"

  # Future phase: Add strict MFA constraints here for risky logins
}

# Priority 3: The Default User Experience
resource "okta_policy_rule_signon" "passwordless_default_rule" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Passwordless - All Users"
  status    = "ACTIVE"
  priority  = 3

  access = "ALLOW"

  # Future phase: Add FastPass/FIDO2 constraints here
}