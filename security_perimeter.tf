# =============================================================================
# 🛡️ SECURITY PERIMETER (Phase 2)
# =============================================================================

# --- 1. NETWORK ZONES ---

# Dynamic Zone: Tenant-level Blocklist
resource "okta_network_zone" "proxy_check" {
  name   = "TF Managed - Proxy & VPN Zone"
  type   = "DYNAMIC_V2"
  usage  = "BLOCKLIST"
  status = "ACTIVE"

  # 1. THE BASELINE: Verified via State Peeking
  ip_service_categories_include = [
    "ALL_IP_SERVICES"
  ]

  # 2. THE EXCEPTION: Carve Apple out
  ip_service_categories_exclude = [
    "APPLE_ICLOUD_RELAY_PROXY"
  ]
}

# --- 2. GLOBAL SESSION POLICY ---

# The overarching policy container
resource "okta_policy_signon" "global_secure" {
  name        = "Global Security Perimeter"
  status      = "ACTIVE"
  description = "Baseline security policy. Mastered in Okta via Terraform."

  # Lock in the 'Everyone' group to prevent detachment
  groups_included = ["00g1100e6nrqyrHst698"]
}

# --- 3. AUTHENTICATORS ---

# Enable Okta Verify (Push & TOTP)
resource "okta_authenticator" "okta_verify" {
  name   = "Okta Verify"
  key    = "okta_verify"
  status = "ACTIVE"
}

# Enable WebAuthn (FIDO2 / Biometrics / YubiKeys)
resource "okta_authenticator" "webauthn" {
  name   = "FIDO2 (WebAuthn)"
  key    = "webauthn"
  status = "ACTIVE"
}