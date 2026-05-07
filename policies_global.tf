# =============================================================================
# 🌍 GLOBAL SESSION POLICIES (Phase 2)
# =============================================================================

# Existing Policy: Passwordless & FIDO2
resource "okta_policy_signon" "fastpass" {
  name   = "Passwordless - FastPass & FIDO2"
  status = "ACTIVE"

  # Adopt the live description
  description = "Primary global authentication policy: passwordless-first."

  # Hardcode the existing group ID to prevent detachment
  groups_included = ["00g1100e6nrqyrHst698"]
}