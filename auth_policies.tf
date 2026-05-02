# 1. Create the Policy Container
resource "okta_app_signon_policy" "passwordless_policy" {
  name        = "Passwordless Policy"
  description = "Enforces Passwordless via FastPass or FIDO2"
}

# 2. Add the Passwordless Rule
resource "okta_app_signon_policy_rule" "passwordless_rule" {
  policy_id = okta_app_signon_policy.passwordless_policy.id
  name      = "Require Any 2 Factors"
  priority  = 1

  groups_included = [okta_group.engineering.id]

  # This native setting requires two different factor types
  # and natively allows FastPass (Possession + Biometric) or Standard (Password + Push)
  factor_mode = "2FA"

  # Notice there is no "constraints" block here anymore!
}