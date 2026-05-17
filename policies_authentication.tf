# -----------------------------------------------------------------------------
# 🔐 APP AUTHENTICATION POLICIES
# -----------------------------------------------------------------------------
# This file defines app-specific authentication policies that override global policies.

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