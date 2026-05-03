# ============================================================================
# 🌐 GLOBAL NETWORK ZONES
# ============================================================================

resource "okta_network_zone" "proxy_check" {
  name  = "Detected Proxies & VPNs"
  type  = "DYNAMIC_V2"
  usage = "POLICY"

  ip_service_categories_include = ["ALL_ANONYMIZERS"]
  ip_service_categories_exclude = ["APPLE_ICLOUD_RELAY_PROXY"]
}