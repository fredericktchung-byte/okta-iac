# ============================================================================
# 📱 APPLICATION-SPECIFIC POLICIES
# ============================================================================
# This file contains application-specific sign-on policies and rules.
# Most resources are auto-generated from Okta's REST API exports.
# The name attribute on each rule explains its purpose.
resource "okta_app_signon_policy" "any_two_factors" {
  name        = "Any two factors"
  description = "Default policy requiring any two factors for access."
}

resource "okta_app_signon_policy" "okta_admin_console" {
  name        = "Okta Admin Console"
  description = "Specific policy for the Admin Console application."
}
# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "rst110b2a9vaqwvNd698/rul110b2a9wcDu7jX698"
resource "okta_app_signon_policy_rule" "passwordless_policy_catch_all_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = ["{\"possession\":{\"required\":true,\"deviceBound\":\"REQUIRED\"}}"]
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Catch-all Rule"
  network_connection          = null
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst110b2a9vaqwvNd698"
  priority                    = 99
  re_authentication_frequency = "PT12H"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = null
  user_types_included         = null
  users_excluded              = null
  users_included              = null
}

# __generated__ by Terraform from "rst1100ocn8KyHwwy698/rul1100ocn9GryB9v698"
resource "okta_app_signon_policy_rule" "okta_admin_console_catch_all_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = ["{\"knowledge\":{\"reauthenticateIn\":\"PT12H\",\"types\":[\"password\"],\"required\":true}}"]
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Catch-all Rule"
  network_connection          = null
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocn8KyHwwy698"
  priority                    = 99
  re_authentication_frequency = "PT12H"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = null
  user_types_included         = null
  users_excluded              = null
  users_included              = null
}

# __generated__ by Terraform from "rst1100ocniwX0LKU698/rul1100ocnjit8J5i698"
resource "okta_app_signon_policy_rule" "okta_browser_plugin_catch_all_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = []
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Catch-all Rule"
  network_connection          = null
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocniwX0LKU698"
  priority                    = 99
  re_authentication_frequency = "PT12H"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = null
  user_types_included         = null
  users_excluded              = null
  users_included              = null
}

# __generated__ by Terraform from "rst110b2a9vaqwvNd698/rul110b8syhys7hV8698"
resource "okta_app_signon_policy_rule" "passwordless_policy_require_any_2_factors" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = []
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA"
  groups_excluded             = []
  groups_included             = [okta_group.engineering.id]
  inactivity_period           = null
  name                        = "Require Any 2 Factors"
  network_connection          = "ANYWHERE"
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst110b2a9vaqwvNd698"
  priority                    = 1
  re_authentication_frequency = "PT2H"
  risk_score                  = "ANY"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = []
  user_types_included         = []
  users_excluded              = []
  users_included              = []
}

# __generated__ by Terraform from "rst1100ocounwYZqf698/rul1100ocoxeGGYjW698"
resource "okta_app_signon_policy_rule" "okta_account_management_policy_password_expiry_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = ["{\"knowledge\":{\"types\":[\"password\"],\"required\":true}}"]
  custom_expression           = "accessRequest.operation=='recover' && accessRequest.metadata.type=='expiry'"
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "1FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Password Expiry Rule"
  network_connection          = "ANYWHERE"
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocounwYZqf698"
  priority                    = 0
  re_authentication_frequency = "PT0S"
  risk_score                  = "ANY"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = []
  user_types_included         = []
  users_excluded              = []
  users_included              = []
}

# __generated__ by Terraform from "rst1100ocycunxx40698/rul1100ocydrl2kk6698"
resource "okta_app_signon_policy_rule" "okta_oin_submission_tester_catch_all_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = ["{\"knowledge\":{\"types\":[\"password\"],\"required\":true}}"]
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "1FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Catch-all Rule"
  network_connection          = null
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocycunxx40698"
  priority                    = 99
  re_authentication_frequency = "PT2H"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = null
  user_types_included         = null
  users_excluded              = null
  users_included              = null
}

# __generated__ by Terraform from "rst1100ocn8KyHwwy698/rul1100ocnbbALn2M698"
resource "okta_app_signon_policy_rule" "okta_admin_console_admin_app_policy" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = ["{\"knowledge\":{\"reauthenticateIn\":\"PT43800H\",\"types\":[\"password\"],\"required\":true}}"]
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Admin App Policy"
  network_connection          = "ANYWHERE"
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocn8KyHwwy698"
  priority                    = 0
  re_authentication_frequency = "PT0S"
  risk_score                  = "ANY"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = []
  user_types_included         = []
  users_excluded              = []
  users_included              = []
}

# __generated__ by Terraform from "rst1100ocnf1gxDSr698/rul1100ocngs6fY0F698"
resource "okta_app_signon_policy_rule" "okta_dashboard_catch_all_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = []
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Catch-all Rule"
  network_connection          = null
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocnf1gxDSr698"
  priority                    = 99
  re_authentication_frequency = "PT12H"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = null
  user_types_included         = null
  users_excluded              = null
  users_included              = null
}

# __generated__ by Terraform from "rst1100ocnsvLBtu1698/rul1100ocntwPXE7g698"
resource "okta_app_signon_policy_rule" "any_two_factors_catch_all_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = []
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Catch-all Rule"
  network_connection          = null
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocnsvLBtu1698"
  priority                    = 99
  re_authentication_frequency = "PT12H"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = null
  user_types_included         = null
  users_excluded              = null
  users_included              = null
}

# __generated__ by Terraform from "rst1100ocounwYZqf698/rul1100ocovHfaK29698"
resource "okta_app_signon_policy_rule" "okta_account_management_policy_catch_all_rule" {
  access                      = "ALLOW"
  chains                      = null
  constraints                 = []
  custom_expression           = null
  device_assurances_included  = null
  device_is_managed           = null
  device_is_registered        = null
  factor_mode                 = "2FA_If_Possible"
  groups_excluded             = null
  groups_included             = null
  inactivity_period           = null
  name                        = "Catch-all Rule"
  network_connection          = null
  network_excludes            = null
  network_includes            = null
  policy_id                   = "rst1100ocounwYZqf698"
  priority                    = 99
  re_authentication_frequency = "PT0S"
  status                      = "ACTIVE"
  type                        = "ASSURANCE"
  user_types_excluded         = null
  user_types_included         = null
  users_excluded              = null
  users_included              = null
}
