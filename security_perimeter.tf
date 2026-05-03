# =============================================================================
# 🛡️ SECURITY PERIMETER (Phase 2)
# =============================================================================

# --- 1. NETWORK ZONES ---

# Dynamic Zone: Detect and manage high-risk IP routing
resource "okta_network_zone" "proxy_check" {
  name  = "Zone - Detected Proxies & VPNs"
  type  = "DYNAMIC_V2"
  usage = "POLICY"

  # Target known proxy and Tor exit node IP ranges
  ip_service_categories_include = [
    "ALL_ANONYMIZERS"
  ]

  # Explicitly allow Apple devices using standard privacy features
  ip_service_categories_exclude = [
    "APPLE_ICLOUD_RELAY_PROXY"
  ]
}

# --- 2. GLOBAL SESSION POLICY & RULES ---

# The overarching policy container
resource "okta_policy_signon" "global_secure" {
  name        = "Global Security Perimeter"
  status      = "ACTIVE"
  description = "Baseline security policy. Mastered in Okta via Terraform."
}

# Rule 1: Drop high-risk traffic immediately
resource "okta_policy_rule_signon" "block_proxies" {
  policy_id = okta_policy_signon.global_secure.id
  name      = "Block Detected Proxies & VPNs"
  status    = "ACTIVE"

  # Condition: If traffic matches our proxy zone...
  network_connection = "ZONE"
  network_includes   = [okta_network_zone.proxy_check.id]

  # Action: ...Drop it before authentication begins
  access   = "DENY"
  priority = 1
}