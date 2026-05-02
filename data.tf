# 1. Query the Okta API for the built-in default policy
data "okta_default_policy" "global_session" {
  type = "OKTA_SIGN_ON"
}

# 2. Tell Terraform to print the ID to your console
output "hidden_default_policy_id" {
  value       = data.okta_default_policy.global_session.id
  description = "The hidden API ID for the Default Global Session Policy"
}

# Find the built-in "Everyone" group
data "okta_everyone_group" "everyone" {}

data "okta_app_signon_policy" "any_two_factors" {
  app_id = "0oa1100e6m0X0EQrA698" # Replace with YOUR actual ID
}