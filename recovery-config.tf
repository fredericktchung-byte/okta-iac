# ============================================================================
# OKTA ACCOUNT RECOVERY CONFIGURATION - PASSWORDLESS RESILIENCE
# ============================================================================
# Phase 4c: Account recovery flows for passwordless authentication
#
# When passwords are disabled, users need secure recovery mechanisms:
# 1. Admin-assisted recovery (primary): Admin resets user device trust
# 2. Emergency contact recovery: Trusted contact can assist recovery
# 3. Recovery codes: User-generated backup codes for self-service
# 4. Device unlock: Override device binding temporarily for account access
#
# Goal: Enable account recovery without password fallback, maintaining
#       zero-trust principles while ensuring user access.
#
# Important: These resources must be configured BEFORE disabling password
#           and email authenticators (Phases 4d and 4e).
# ============================================================================

# ============================================================================
# RECOVERY ADMIN GROUP
# ============================================================================
# Scope admin recovery operations to a specific group.
# This allows fine-grained access control (e.g., Level-2 support team).

resource "okta_group" "account_recovery_admins" {
  name        = "Account Recovery Admins"
  description = "Administrators authorized to perform account recovery operations for passwordless users. Members can reset device trust, issue recovery codes, and assist with account unlock."
}

# ============================================================================
# EMERGENCY CONTACT GROUP
# ============================================================================
# Emergency contacts are designated users who can assist in account recovery
# without requiring password. This is a social engineering defense layer:
# Recovery requires contact's approval to prevent unauthorized account access.

resource "okta_group" "emergency_contacts" {
  name        = "Emergency Contacts"
  description = "Trusted users who can assist account owners with account recovery. Used as a fallback recovery mechanism when primary authenticators are unavailable."
}

# ============================================================================
# DEVICE TRUST ADMINISTRATORS GROUP
# ============================================================================
# When a user loses access to bound device, recovery flow:
# 1. User initiates recovery request
# 2. Admin reviews request (manual verification)
# 3. Admin clears device trust (resets device binding)
# 4. User re-enrolls authenticators
# 5. Session resumed

resource "okta_group" "device_trust_administrators" {
  name        = "Device Trust Administrators"
  description = "Administrators with permission to reset device trust bindings for user accounts. Used during device recovery or security incident response."
}

# ============================================================================
# RECOVERY POLICY: Account Recovery Support
# ============================================================================
# This policy is applied globally for account recovery assistance.
# In practice, recovery flows are managed through:
# 1. Okta Admin Console > Security > Account Recovery
# 2. Okta Management API (POST /api/v1/users/{uid}/recovery-codes)
# 3. Custom Okta Workflows for emergency contact approval

resource "okta_policy_signon" "account_recovery" {
  name            = "Account Recovery - Passwordless Support"
  description     = "Recovery policy for passwordless accounts. Enables admin-assisted recovery and emergency contact assistance. No password required for recovery validation."
  status          = "ACTIVE"
  priority        = 10
  groups_included = []
}

# ============================================================================
# RECOVERY CODES SETUP (DOCUMENTATION)
# ============================================================================
# The Okta Terraform provider does not expose recovery codes resources directly.
# Recovery codes are generated and managed via Okta APIs:
#
# 1. Generate recovery codes for user:
#    POST /api/v1/users/{uid}/recovery-codes
#    Returns: Array of backup codes (use these for account access if device lost)
#
# 2. List user's recovery codes:
#    GET /api/v1/users/{uid}/recovery-codes
#
# 3. User self-service (Okta Admin Console):
#    Go to user profile > Settings > Account > Recovery codes > Generate
#
# Implementation options:
# - Use Okta MCP server (okta/mcp-server) for programmatic generation
# - Use Okta CLI: okta login && okta api /api/v1/users/{uid}/recovery-codes -m POST
# - Use custom Okta Workflows automation
# - Integrate with Okta Verify app (generates codes on enroll)
#
# Reference: https://developer.okta.com/docs/api/openapi/okta-management/management/tag/recovery-codes/

# ============================================================================
# RECOVERY FLOWS - OPERATIONAL PROCEDURES
# ============================================================================

# RECOVERY FLOW 1: Admin-Assisted Recovery
# ==========================================
# Prerequisites:
# - User is ACTIVE but cannot authenticate (lost device, etc.)
# - Admin has account_recovery_admins group membership
#
# Okta Admin Console procedure:
# 1. Navigate to Users > Users (find user)
# 2. Click "Reset Authenticators" or "Reset Password"
# 3. System sends recovery link to user's email
# 4. User clicks link, re-enrolls Okta Verify + WebAuthn
# 5. User authenticates with new device binding
#
# Okta Management API procedure (automated):
# DELETE /api/v1/users/{uid}/factors/{fid}   # Reset factor
# POST /api/v1/users/{uid}/recovery-codes    # Issue recovery codes
# See: https://developer.okta.com/docs/api/openapi/okta-management/management/tag/user-factors/

# RECOVERY FLOW 2: Emergency Contact Assistance
# ===============================================
# Prerequisites:
# - User has designated emergency contact (in user profile)
# - Emergency contact is member of emergency_contacts group
# - Both user and contact can authenticate independently
#
# Operational procedure:
# 1. User cannot authenticate, notifies emergency contact
# 2. Emergency contact logs into Okta Admin Console
# 3. Contact approves recovery request (after verifying identity)
# 4. System generates temporary recovery code or token
# 5. User uses recovery code/token to reset device
# 6. User re-enrolls authenticators
#
# Implementation: Requires Okta Workflows integration or custom portal
# (Okta doesn't provide native "emergency contact approval" UI)

# RECOVERY FLOW 3: Self-Service Recovery with Backup Codes
# ==========================================================
# Prerequisites:
# - User has saved recovery codes (generated during enrollment)
# - User has alternate device or access to backup email
#
# Okta login procedure:
# 1. Go to Okta login page
# 2. Click "Can't access your authenticator?" or "Use recovery code"
# 3. Enter recovery code (shown at enrollment time)
# 4. System verifies code and allows limited session
# 5. User re-enrolls devices or confirms identity
#
# Implementation: Okta native functionality (automatic when codes enabled)
# Reference: https://help.okta.com/okta_help.htm?id=ext_Recovery_Codes

# ============================================================================
# MONITORING & ALERTING FOR RECOVERY EVENTS
# ============================================================================
# Track recovery operations via Okta System Log:
# GET /api/v1/logs?filter=eventType eq "system.user_auth_attest_error"
#
# Monitor for:
# - Failed authentication attempts (potential account compromise)
# - Device binding resets (admin-initiated recovery)
# - Recovery code usage (indicates device loss)
# - Emergency contact requests (potential fraud)
#
# Set up alerts in Okta system logs if:
# - >5 failed auth attempts in 10 minutes (might indicate attack)
# - Device binding reset outside normal hours (potential unauthorized)
# - Recovery code used >3 times (device repeatedly lost?)
#
# Implementation: Okta Workflows + email/Slack notification, or
#                 CloudWatch/Datadog ingestion of system logs

# ============================================================================
# DEPLOYMENT CHECKLIST - PHASE 4c
# ============================================================================
# [ ] Create account_recovery_admins group (this file) ✓
# [ ] Create emergency_contacts group (this file) ✓
# [ ] Create device_trust_administrators group (this file) ✓
# [ ] Create account_recovery policy (this file) ✓
# [ ] Apply policy rule to all users (terraform apply)
# [ ] Configure recovery methods in each user's profile:
#     - Add emergency contact information
#     - Ensure alternate email configured
#     - Enable SMS recovery (optional)
# [ ] Test admin recovery flow:
#     - Reset authenticator via Admin API
#     - Verify user can re-enroll
# [ ] Test emergency contact flow (if implemented)
# [ ] Verify recovery notification emails deliver
# [ ] Document recovery procedures for support team
# [ ] Notify users of recovery procedures
# [ ] Create health-check.sh to verify recovery endpoints
# [ ] Set up monitoring alerts for recovery failures
#
# Rollback: Delete recovery policies and re-enable email/password if needed
#           (see PASSWORDLESS_DEPLOYMENT_STRATEGY.md for rollback procedure)

# ============================================================================
# INTEGRATION WITH OKTA MCP SERVER
# ============================================================================
# To automate recovery code generation in CI/CD, use okta/mcp-server:
#
# 1. Set up okta-mcp-server in Docker (see OKTA_MCP_SETUP.md)
# 2. Configure Copilot CLI to use MCP integration
# 3. Use prompts like:
#    "Generate recovery codes for user john.doe@example.com"
#    "Reset all authenticators for user with ID 00u..."
#    "List emergency contacts for all users"
#
# MCP integration enables:
# - Automated recovery code management in CI/CD pipelines
# - Bulk user recovery operations
# - Real-time recovery status dashboard
# - Emergency recovery automation during incidents
#
# See: OKTA_MCP_SETUP.md for detailed setup instructions

# ============================================================================
# PHASE 4c COMPLETION CRITERIA
# ============================================================================
# - Recovery admin group created and populated with at least 2 admins
# - Emergency contact group created (can be empty initially)
# - Device trust admin group created (can be scoped to Level-2 support)
# - Recovery policy deployed (status: ACTIVE)
# - All users can recover via admin-assisted mechanism
# - Support team trained on recovery procedures
# - Health checks passing for recovery endpoints
# - Monitoring/alerting configured for recovery failures
# - Documentation published to support team wiki
#
# After Phase 4c is complete and tested (48 hours observation):
# → Proceed to Phase 5: Disable email and password authenticators

# ============================================================================
# DEPENDENCIES & PREREQUISITES
# ============================================================================
# Phase 4c REQUIRES:
# - Phase 1: Okta Verify FastPass enabled (COMPLETE) ✓
# - Phase 2: WebAuthn/FIDO2 configured (COMPLETE) ✓
# - Phase 3: Passwordless policy created (COMPLETE) ✓
# - Phase 4a: Passwordless policy rules deployed (COMPLETE) ✓
# - Phase 4b: Admin policies configured (COMPLETE) ✓
#
# Phase 4c ENABLES:
# - Phase 5: Disable email authenticator
# - Phase 5: Disable password authenticator (final step)
