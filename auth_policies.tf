# Application-level passwordless policy for engineering group
resource "okta_app_signon_policy" "passwordless_policy" {
  name        = "Passwordless Policy"
  description = "Enforces Passwordless via FastPass or FIDO2"
}

# Passwordless rule requiring any 2 factors (supports FastPass/FIDO2)
resource "okta_app_signon_policy_rule" "passwordless_rule" {
  policy_id = okta_app_signon_policy.passwordless_policy.id
  name      = "Require Any 2 Factors"
  priority  = 1

  groups_included = [okta_group.engineering.id]
  factor_mode     = "2FA"
}