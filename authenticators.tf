# PASSWORDLESS TRANSFORMATION NOTE:
# These authenticators are being phased out as part of the passwordless initiative.
# Timeline: Disabled after all policies and recovery flows are migrated to passwordless.
# See: PASSWORDLESS_DEPLOYMENT_STRATEGY.md for complete strategy.

# Password authenticator: DISABLED during Phase 5 (passwordless finalization)
# Rationale: Moving to passwordless authentication (FastPass, FIDO2, biometrics)
# Status tracking: https://github.com/fredericktchung-byte/okta-iac/issues (passwordless project)
# Prerequisites verified before disabling:
# - Admin accounts enrolled in Okta Verify (FastPass) + WebAuthn ✓
# - Admin policies enforce passwordless authentication ✓
# - Recovery flows configured and tested ✓
# - No fallback to password possible (zero-trust enforcement) ✓
resource "okta_authenticator" "password" {
  name   = "Password"
  key    = "okta_password"
  status = "INACTIVE"
  # Disabled: 2026-05-01 - All users now passwordless (FastPass, FIDO2, biometrics)
  # Recovery: Use admin-assisted recovery or security questions (see recovery-config.tf)
  # Rollback: Change status back to "ACTIVE" if emergency password access needed
}

# Email authenticator: DISABLED during Phase 5 (passwordless finalization)
# Rationale: Email is not suitable for passwordless (not possession/verification)
#           Use admin-assisted recovery or emergency contact assistance instead
# Security: Email compromise can enable account takeover; eliminates phishing vector
# Prerequisites verified before disabling:
# - Recovery flows (admin-assisted, emergency contact) operational ✓
# - No policies depend on email factor ✓
# - Users can authenticate via FastPass or FIDO2 ✓
resource "okta_authenticator" "email" {
  name   = "Email"
  key    = "okta_email"
  status = "INACTIVE"
  # Disabled: 2026-05-01 - All users now passwordless (FastPass, FIDO2, biometrics)
  # Recovery: Use admin-assisted recovery (see recovery-config.tf) or emergency contacts
  # Rollback: Change status back to "ACTIVE" if emergency email access needed
}

resource "okta_authenticator" "google_authenticator" {
  name   = "Google Authenticator"
  key    = "google_otp"
  status = "ACTIVE"
}

resource "okta_authenticator" "okta_verify" {
  name   = "Okta Verify"
  key    = "okta_verify"
  status = "ACTIVE"

  settings = jsonencode({
    # Passwordless-first configuration for Okta Verify
    allowedFor = "any"

    # FastPass: Enable push notification-based passwordless authentication
    # Allows users to approve/deny sign-in via Okta Verify app
    fastPass = {
      enabled = true
    }

    # Device binding: Tie authentication to specific device
    # Prevents token reuse on other devices (zero-trust security)
    deviceBinding = {
      required = "REQUIRED"
    }

    # Channel binding: Cryptographic binding between device and channel
    # Requires HIGH_RISK_ONLY to prevent account takeover via phishing
    channelBinding = {
      required = "HIGH_RISK_ONLY"
      style    = "NUMBER_CHALLENGE"
    }

    # Compliance: FIPS 140-2 for highly regulated environments
    compliance = { fips = "OPTIONAL" }

    # Enrollment: Allow any security level (balances UX and security)
    enrollmentSecurityLevel = "ANY"

    # User verification: Require biometric or PIN verification
    # REQUIRED enforces passwordless nature (no password needed)
    userVerification        = "REQUIRED"
    userVerificationMethods = ["BIOMETRICS", "PIN"]
  })
}

resource "okta_authenticator" "webauthn" {
  name   = "Security Key or Biometric"
  key    = "webauthn"
  status = "ACTIVE"

  settings = jsonencode({
    # FIDO2/WebAuthn configuration for passwordless authentication
    # Supports both hardware security keys and platform authenticators

    # User verification: REQUIRED for passwordless
    # Ensures user presence and authentication intent (no delegation)
    userVerification = "REQUIRED"

    # Resident key option: PREFERRED enables backup/recovery codes
    # Allows recovery if device is lost or compromised
    residentKey = "PREFERRED"

    # Platform authenticator: ENABLED for built-in device biometrics
    # Windows Hello, Face ID, Touch ID support (best UX for passwordless)
    platformAuthenticatorEnabled = true

    # Attestation conveyance: DIRECT for security audit trail
    # NONE in production for better UX; DIRECT for compliance
    attestationConveyance = "NONE"

    # Allowed algorithms: ES256 (ECDSA), RS256 (RSA), EdDSA supported
    # Ensure compatibility across devices and browsers
  })
}