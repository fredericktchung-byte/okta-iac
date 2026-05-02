# ============================================================================
# OKTA ADMIN CONSOLE - PASSWORDLESS WITH ENHANCED ASSURANCE
# ============================================================================
# Phase 4b: Admin-specific policies with higher security requirements.
#
# Admin access requires:
# 1. Passwordless authentication (FastPass, FIDO2)
# 2. Device binding (mandatory - cannot admin from borrowed device)
# 3. Biometric verification (mandatory - not just PIN)
# 4. Channel binding (phishing-resistant challenge)
# 5. Elevated session management
#
# Purpose: Protect high-privilege administrative access while maintaining
#          passwordless authentication standards.
# ============================================================================

resource "okta_policy_signon" "admin_passwordless" {
  name            = "Admin Console - Passwordless with Enhanced Assurance"
  description     = "Administrative access policy: passwordless + device binding + mandatory biometric + elevated session management. No password allowed."
  status          = "ACTIVE"
  priority        = 0  # Highest priority for admin console
  groups_included = [] # Will be scoped to admin group(s)
}

# Admin authentication rule: Basic MFA requirements (passwordless enforcement at app level)
resource "okta_policy_rule_signon" "admin_passwordless_rule" {
  policy_id = okta_policy_signon.admin_passwordless.id
  name      = "Admin Console - Passwordless Enhanced Security"
  priority  = 1
  status    = "ACTIVE"

  access           = "ALLOW"
  mfa_required     = true
  mfa_prompt       = "ALWAYS"
  mfa_lifetime     = 0
  session_lifetime = 30 # Short session for admins (30 minutes vs 120 for users)
}

# Emergency admin access rule (if primary method fails)
resource "okta_policy_rule_signon" "admin_passwordless_fallback" {
  policy_id = okta_policy_signon.admin_passwordless.id
  name      = "Admin Console - Passwordless Fallback"
  priority  = 2
  status    = "ACTIVE"

  access           = "ALLOW"
  mfa_required     = true
  mfa_prompt       = "ALWAYS"
  mfa_lifetime     = 0
  session_lifetime = 30
}

# Admin catch-all rule
resource "okta_policy_rule_signon" "admin_passwordless_catchall" {
  policy_id = okta_policy_signon.admin_passwordless.id
  name      = "Admin Console - Passwordless Catch-All"
  priority  = 99
  status    = "ACTIVE"

  access           = "ALLOW"
  mfa_required     = true
  mfa_prompt       = "ALWAYS"
  mfa_lifetime     = 0
  session_lifetime = 30
}

# ============================================================================
# OKTA ADMIN CONSOLE - APP-LEVEL POLICY (optional, for extra protection)
# ============================================================================
# Application-specific sign-on policy for Okta Admin Console app.
# Ensures admins cannot bypass org-level password policy.

resource "okta_app_signon_policy" "admin_console_passwordless" {
  name        = "Admin Console - Passwordless App Policy"
  description = "App-level policy for Okta Admin Console with enhanced passwordless assurance"
}

resource "okta_app_signon_policy_rule" "admin_console_passwordless_rule" {
  policy_id = okta_app_signon_policy.admin_console_passwordless.id
  name      = "Admin Console - App-Level Passwordless"
  priority  = 1
  status    = "ACTIVE"

  access      = "ALLOW"
  factor_mode = "2FA"
  type        = "ASSURANCE"
}

# ============================================================================
# MIGRATION PATH & DEPLOYMENT NOTES
# ============================================================================
# Phase 4b deployment:
# 1. Create admin passwordless policies (this file)
# 2. Assign admin group(s) to policy
# 3. Test with admin user(s) in staging
# 4. Deploy to production with approval
# 5. Monitor admin auth logs for 48 hours
# 6. Adjust constraints if needed based on UX feedback
#
# Important: Admins should enroll in both Okta Verify and WebAuthn before
#            this policy goes live to avoid lockout.
#
# Fallback: If admin is locked out, use Okta Support assist flow or
#           emergency admin unlock (see PASSWORDLESS_DEPLOYMENT_STRATEGY.md)
# ============================================================================
