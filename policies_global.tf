# ============================================================================
# 📁 GLOBAL POLICY: PASSWORDLESS AUTHENTICATION
# ============================================================================
# This file defines the primary global sign-on policy for passwordless access.
# It enables FastPass and FIDO2 authentication across the organization.

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

# Rule 1: Block proxy/VPN traffic (except iCloud)
resource "okta_policy_rule_signon" "block_proxies_allow_icloud" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Block Detected Proxies & VPNs (Allow iCloud)"
  status    = "ACTIVE"
  priority  = 1

  network_connection = "ZONE"
  network_includes   = [okta_network_zone.proxy_check.id]

  access = "DENY"
}

# Rule 2: Extra auth for high-risk sign-ins
resource "okta_policy_rule_signon" "passwordless_high_risk" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Step-Up Auth for High Risk Sign-ins"
  status    = "ACTIVE"
  priority  = 2

  risk_level = "HIGH"

  access = "ALLOW"
}

# Rule 3: Default - allow passwordless to everyone
resource "okta_policy_rule_signon" "passwordless_default_rule" {
  policy_id = okta_policy_signon.passwordless.id
  name      = "Passwordless - All Users"
  status    = "ACTIVE"
  priority  = 3

  access = "ALLOW"
}