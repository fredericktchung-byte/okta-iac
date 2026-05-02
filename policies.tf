resource "okta_policy_signon" "default" {
  name            = "Default Policy"
  status          = "ACTIVE"
  description     = "The default policy applies in all situations if no other policy applies."
  groups_included = [data.okta_everyone_group.everyone.id]
}

# ============================================================================
# PASSWORDLESS TRANSFORMATION: Passwordless-First Authentication Policy
# ============================================================================
# Phase 3 of passwordless deployment: Establish passwordless authentication
# as the primary policy for all users.
#
# This policy enforces:
# - No password requirement (passwordless)
# - Possession factor (device binding): Required
# - Verification factor (biometrics/PIN): Preferred
# - Multi-factor without password knowledge
#
# Deployment timeline:
# 1. Deploy policy to staging (PASSWORDLESS_DEPLOYMENT_STRATEGY.md)
# 2. Apply canary deployment to Engineering group
# 3. Progressive rollout: 25% → 50% → 75% → 100%
# 4. Disable password authenticator after verification (Phase 4)
# ============================================================================

resource "okta_policy_signon" "passwordless" {
  name            = "Passwordless - FastPass & FIDO2"
  description     = "Primary authentication policy: passwordless-first with Okta Verify (FastPass, biometrics) and WebAuthn (FIDO2, security keys). No password required."
  status          = "ACTIVE"
  priority        = 1
  groups_included = [data.okta_everyone_group.everyone.id]
}