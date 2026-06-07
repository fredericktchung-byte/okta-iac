# =============================================================================
# 🛡️ SECURITY PERIMETER
# =============================================================================

# --- NETWORK ZONES ---

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
    "APPLE_ICLOUD_RELAY_PROXY",
    "WARP_VPN"
  ]
}

# Dynamic Zone: High-Risk Geographies
resource "okta_network_zone" "high_risk_countries" {
  name   = "TF Managed - High-Risk Countries"
  type   = "DYNAMIC"
  usage  = "BLOCKLIST"
  status = "ACTIVE"

  # Define countries via ISO-3166-1 Alpha-2 codes
  dynamic_locations = [
    "IR", # Iran
    "KP", # North Korea
    "RU", # Russia
    "VE", # Venezuela
    "SO", # Somalia
    "SD", # Sudan
    "SY", # Syria
    "YE"  # Yemen
  ]
}

# Dynamic Blocklist managed by Tines SOAR
resource "okta_network_zone" "threat_intel_ips" {
  # id     = "nzo137zq0zyTv9XgO698"
  name   = "SOAR Managed - Threat Intel Blocklist"
  type   = "IP"
  usage  = "BLOCKLIST"
  status = "ACTIVE"

  # Initial loopback dummy IP to satisfy the provider schema
  gateways = ["127.0.0.1/32"]

  # CRITICAL: Prevent Terraform state drift when Tines updates the IPs
  lifecycle {
    ignore_changes = [gateways]
  }
}

# Output the Zone ID so you can easily copy it into your Tines webhook
output "threat_intel_zone_id" {
  value       = okta_network_zone.threat_intel_ips.id
  description = "The ID of the Network Zone for Tines to update via API"
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