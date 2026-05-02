# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "okta_app_oauth" "okta_admin_console" {
  accessibility_error_redirect_url = null
  accessibility_login_redirect_url = null
  accessibility_self_service       = false
  admin_note                       = null
  app_links_json                   = null
  app_settings_json = jsonencode({
    app                = {}
    manualProvisioning = false
  })
  authentication_policy                = "rst1100ocn8KyHwwy698"
  auto_key_rotation                    = null
  auto_submit_toolbar                  = false
  client_basic_secret                  = null # sensitive
  client_uri                           = null
  consent_method                       = null
  enduser_note                         = null
  frontchannel_logout_session_required = null
  frontchannel_logout_uri              = null
  hide_ios                             = false
  hide_web                             = false
  implicit_assignment                  = false
  issuer_mode                          = null
  jwks_uri                             = null
  label                                = "Okta Admin Console"
  login_mode                           = null
  login_scopes                         = null
  login_uri                            = null
  logo                                 = null
  logo_uri                             = null
  omit_secret                          = null
  participate_slo                      = null
  policy_uri                           = null
  post_logout_redirect_uris            = null
  profile                              = null
  redirect_uris                        = null
  refresh_token_leeway                 = null
  refresh_token_rotation               = null
  status                               = "ACTIVE"
  token_endpoint_auth_method           = null
  tos_uri                              = null
  type                                 = "WORKFLOWS"
  user_name_template                   = "$${source.login}"
  user_name_template_push_status       = null
  user_name_template_suffix            = null
  user_name_template_type              = "BUILT_IN"
  wildcard_redirect                    = null
}

# __generated__ by Terraform
resource "okta_app_oauth" "okta_oin_submission_tester" {
  accessibility_error_redirect_url = null
  accessibility_login_redirect_url = null
  accessibility_self_service       = false
  admin_note                       = null
  app_links_json                   = null
  app_settings_json = jsonencode({
    app                = {}
    manualProvisioning = false
  })
  authentication_policy                = "rst1100ocycunxx40698"
  auto_key_rotation                    = null
  auto_submit_toolbar                  = false
  client_basic_secret                  = null # sensitive
  client_uri                           = null
  consent_method                       = null
  enduser_note                         = null
  frontchannel_logout_session_required = null
  frontchannel_logout_uri              = null
  hide_ios                             = false
  hide_web                             = false
  implicit_assignment                  = false
  issuer_mode                          = null
  jwks_uri                             = null
  label                                = "Okta OIN Submission Tester"
  login_mode                           = null
  login_scopes                         = null
  login_uri                            = null
  logo                                 = null
  logo_uri                             = null
  omit_secret                          = null
  participate_slo                      = null
  policy_uri                           = null
  post_logout_redirect_uris            = null
  profile                              = null
  redirect_uris                        = null
  refresh_token_leeway                 = null
  refresh_token_rotation               = null
  status                               = "ACTIVE"
  token_endpoint_auth_method           = null
  tos_uri                              = null
  type                                 = "DASHBOARD"
  user_name_template                   = "$${source.login}"
  user_name_template_push_status       = null
  user_name_template_suffix            = null
  user_name_template_type              = "BUILT_IN"
  wildcard_redirect                    = null
}

# __generated__ by Terraform
resource "okta_app_oauth" "okta_workflows_oauth" {
  accessibility_error_redirect_url = null
  accessibility_login_redirect_url = null
  accessibility_self_service       = false
  admin_note                       = null
  app_links_json                   = null
  app_settings_json = jsonencode({
    app = {
      redirectURI   = "https://oauth.workflows.okta.com/oauth/okta/cb"
      serviceDomain = "https://oauth.workflows.okta.com"
    }
    manualProvisioning = false
  })
  authentication_policy                = "rst1100ocnsvLBtu1698"
  auto_key_rotation                    = null
  auto_submit_toolbar                  = false
  client_basic_secret                  = null # sensitive
  client_uri                           = null
  consent_method                       = null
  enduser_note                         = null
  frontchannel_logout_session_required = null
  frontchannel_logout_uri              = null
  hide_ios                             = true
  hide_web                             = true
  implicit_assignment                  = false
  issuer_mode                          = null
  jwks_uri                             = null
  label                                = "Okta Workflows OAuth"
  login_mode                           = null
  login_scopes                         = null
  login_uri                            = null
  logo                                 = null
  logo_uri                             = null
  omit_secret                          = null
  participate_slo                      = null
  policy_uri                           = null
  post_logout_redirect_uris            = null
  profile                              = null
  redirect_uris                        = null
  refresh_token_leeway                 = null
  refresh_token_rotation               = null
  status                               = "ACTIVE"
  token_endpoint_auth_method           = null
  tos_uri                              = null
  type                                 = "OIN_SUBMISSION_TESTER"
  user_name_template                   = "$${source.login}"
  user_name_template_push_status       = null
  user_name_template_suffix            = null
  user_name_template_type              = "BUILT_IN"
  wildcard_redirect                    = null
}

# __generated__ by Terraform
resource "okta_app_oauth" "okta_dashboard" {
  accessibility_error_redirect_url = null
  accessibility_login_redirect_url = null
  accessibility_self_service       = false
  admin_note                       = null
  app_links_json                   = null
  app_settings_json = jsonencode({
    app                = {}
    manualProvisioning = false
  })
  authentication_policy                = "rst1100ocnf1gxDSr698"
  auto_key_rotation                    = null
  auto_submit_toolbar                  = false
  client_basic_secret                  = null # sensitive
  client_uri                           = null
  consent_method                       = null
  enduser_note                         = null
  frontchannel_logout_session_required = null
  frontchannel_logout_uri              = null
  hide_ios                             = false
  hide_web                             = false
  implicit_assignment                  = false
  issuer_mode                          = null
  jwks_uri                             = null
  label                                = "Okta Dashboard"
  login_mode                           = null
  login_scopes                         = null
  login_uri                            = null
  logo                                 = null
  logo_uri                             = null
  omit_secret                          = null
  participate_slo                      = null
  policy_uri                           = null
  post_logout_redirect_uris            = null
  profile                              = null
  redirect_uris                        = null
  refresh_token_leeway                 = null
  refresh_token_rotation               = null
  status                               = "ACTIVE"
  token_endpoint_auth_method           = null
  tos_uri                              = null
  type                                 = "ADMIN_CONSOLE"
  user_name_template                   = "$${source.login}"
  user_name_template_push_status       = null
  user_name_template_suffix            = null
  user_name_template_type              = "BUILT_IN"
  wildcard_redirect                    = null
}

# __generated__ by Terraform
resource "okta_app_oauth" "okta_access_certification_reviews" {
  accessibility_error_redirect_url = null
  accessibility_login_redirect_url = null
  accessibility_self_service       = false
  admin_note                       = null
  app_links_json                   = null
  app_settings_json = jsonencode({
    app = {
      initiateLoginURI = null
    }
    manualProvisioning = false
  })
  authentication_policy                = "rst1100ocnsvLBtu1698"
  auto_key_rotation                    = null
  auto_submit_toolbar                  = false
  client_basic_secret                  = null # sensitive
  client_uri                           = null
  consent_method                       = null
  enduser_note                         = null
  frontchannel_logout_session_required = null
  frontchannel_logout_uri              = null
  hide_ios                             = false
  hide_web                             = false
  implicit_assignment                  = false
  issuer_mode                          = null
  jwks_uri                             = null
  label                                = "Okta Access Certification Reviews"
  login_mode                           = null
  login_scopes                         = null
  login_uri                            = null
  logo                                 = null
  logo_uri                             = null
  omit_secret                          = null
  participate_slo                      = null
  policy_uri                           = null
  post_logout_redirect_uris            = null
  profile                              = null
  redirect_uris                        = null
  refresh_token_leeway                 = null
  refresh_token_rotation               = null
  status                               = "ACTIVE"
  token_endpoint_auth_method           = null
  tos_uri                              = null
  type                                 = "WORKFLOWS_OAUTH"
  user_name_template                   = "$${source.login}"
  user_name_template_push_status       = null
  user_name_template_suffix            = null
  user_name_template_type              = "BUILT_IN"
  wildcard_redirect                    = null
}

# __generated__ by Terraform
resource "okta_app_oauth" "okta_browser_plugin" {
  accessibility_error_redirect_url = null
  accessibility_login_redirect_url = null
  accessibility_self_service       = false
  admin_note                       = null
  app_links_json                   = null
  app_settings_json = jsonencode({
    app                = {}
    manualProvisioning = false
  })
  authentication_policy                = "rst1100ocniwX0LKU698"
  auto_key_rotation                    = null
  auto_submit_toolbar                  = false
  client_basic_secret                  = null # sensitive
  client_uri                           = null
  consent_method                       = null
  enduser_note                         = null
  frontchannel_logout_session_required = null
  frontchannel_logout_uri              = null
  hide_ios                             = false
  hide_web                             = false
  implicit_assignment                  = false
  issuer_mode                          = null
  jwks_uri                             = null
  label                                = "Okta Browser Plugin"
  login_mode                           = null
  login_scopes                         = null
  login_uri                            = null
  logo                                 = null
  logo_uri                             = null
  omit_secret                          = null
  participate_slo                      = null
  policy_uri                           = null
  post_logout_redirect_uris            = null
  profile                              = null
  redirect_uris                        = null
  refresh_token_leeway                 = null
  refresh_token_rotation               = null
  status                               = "ACTIVE"
  token_endpoint_auth_method           = null
  tos_uri                              = null
  type                                 = "BROWSER_PLUGIN"
  user_name_template                   = "$${source.login}"
  user_name_template_push_status       = null
  user_name_template_suffix            = null
  user_name_template_type              = "BUILT_IN"
  wildcard_redirect                    = null
}

# __generated__ by Terraform
resource "okta_app_oauth" "okta_workflows" {
  accessibility_error_redirect_url = null
  accessibility_login_redirect_url = null
  accessibility_self_service       = false
  admin_note                       = null
  app_links_json                   = null
  app_settings_json = jsonencode({
    app = {
      initiateLoginURI = "https://integrator-1501452.workflows.okta.com/oidc/0oa1100vopo1YWLYn698/login"
      redirectURI      = "https://integrator-1501452.workflows.okta.com/oidc/0oa1100vopo1YWLYn698/cb"
    }
    manualProvisioning = false
  })
  authentication_policy                = "rst1100ocnsvLBtu1698"
  auto_key_rotation                    = null
  auto_submit_toolbar                  = false
  client_basic_secret                  = null # sensitive
  client_uri                           = null
  consent_method                       = null
  enduser_note                         = null
  frontchannel_logout_session_required = null
  frontchannel_logout_uri              = null
  hide_ios                             = false
  hide_web                             = false
  implicit_assignment                  = false
  issuer_mode                          = null
  jwks_uri                             = null
  label                                = "Okta Workflows"
  login_mode                           = null
  login_scopes                         = null
  login_uri                            = null
  logo                                 = null
  logo_uri                             = null
  omit_secret                          = null
  participate_slo                      = null
  policy_uri                           = null
  post_logout_redirect_uris            = null
  profile                              = null
  redirect_uris                        = null
  refresh_token_leeway                 = null
  refresh_token_rotation               = null
  status                               = "ACTIVE"
  token_endpoint_auth_method           = null
  tos_uri                              = null
  type                                 = "OIDC"
  user_name_template                   = "$${source.login}"
  user_name_template_push_status       = null
  user_name_template_suffix            = null
  user_name_template_type              = "BUILT_IN"
  wildcard_redirect                    = null
}
