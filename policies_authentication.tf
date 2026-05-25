# -----------------------------------------------------------------------------
# 🔐 APP AUTHENTICATION POLICIES
# -----------------------------------------------------------------------------
# This file defines app-specific authentication policies that override global policies.

# Rule for Bookmark App Policy that allows authentication with no MFA requirement, as long as the user has a valid global session. This is critical for ensuring that users can access bookmark apps without unnecessary friction, while still maintaining security through the global session. By setting the factor mode to "2FA" but not requiring any specific factors, we allow users to authenticate using their existing session without being forced into additional MFA prompts for these less sensitive applications.
resource "okta_app_signon_policy" "bookmark_apps" {
  name        = "Bookmark & Redirect Apps"
  description = "Relaxed policy for Bookmark Apps to prevent double prompting."
  # id              = "rst13d08iqdYEGx9r698"
}

resource "okta_app_signon_policy_rule" "allow_with_session" {
  access      = "ALLOW"
  factor_mode = "1FA"
  # id                          = "rul13d05tzdism38u698"
  name                        = "Allow access with active session"
  network_connection          = "ANYWHERE"
  policy_id                   = "rst13d08iqdYEGx9r698"
  priority                    = 0
  re_authentication_frequency = "PT43800H"
  risk_score                  = "ANY"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
}

# Passwordless & FIDO2 Policy for SAML Apps
resource "okta_app_signon_policy" "passwordless" {
  catch_all   = true
  description = "Enforces Passwordless via FastPass or FIDO2"
  name        = "Passwordless Policy"
  priority    = 1
}
# This is the critical rule that enforces phishing-resistant authentication for all apps that reference this policy. By setting the type to "ASSURANCE" and defining the specific constraint, we ensure that only hardware-backed authenticators that meet the phishing-resistant criteria are allowed, effectively eliminating the possibility of password-based or OTP-based attacks.
resource "okta_app_signon_policy_rule" "passwordless_fastpass" {
  access = "ALLOW"
  constraints = [
    jsonencode(
      {
        knowledge = {
          excludedAuthenticationMethods = [
            {
              key    = "okta_password"
              method = "password"
            },
          ]
          required = false
        }
        possession = {
          phishingResistant = "REQUIRED"
          required          = true
          userVerification  = "OPTIONAL"
        }
      }
    ),
  ]
  factor_mode                 = "2FA"
  name                        = "Enforce Phishing Resistance"
  network_connection          = "ANYWHERE"
  policy_id                   = "rst110b2a9vaqwvNd698"
  priority                    = 1
  re_authentication_frequency = "PT2H"
  risk_score                  = "ANY"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
}