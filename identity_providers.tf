resource "okta_idp_oidc" "auth0_ciam" {
  name             = "Auth0 CIAM"
  issuer_url       = "https://dev-qx7clbs8tjgfblbp.us.auth0.com/"
  client_id        = "0wppwnB4Z77owkbPBDJ6QJXOGrAS3Bw5"
  client_secret_wo = var.auth0_client_secret # Correct variable reference

  # OIDC Endpoints
  authorization_url = "https://dev-qx7clbs8tjgfblbp.us.auth0.com/authorize"
  token_url         = "https://dev-qx7clbs8tjgfblbp.us.auth0.com/oauth/token"
  jwks_url          = "https://dev-qx7clbs8tjgfblbp.us.auth0.com/.well-known/jwks.json"

  # Correct Binding Types for OIDC
  authorization_binding = "HTTP-REDIRECT" # User redirected to Auth0
  token_binding         = "HTTP-POST"     # Server-to-server token exchange
  jwks_binding          = "HTTP-REDIRECT"

  scopes             = ["openid", "profile", "email"]
  username_template  = "idpuser.email"
  subject_match_type = "USERNAME"
}
# =============================================================================
# IDP ROUTING RULES
# =============================================================================

# 1. Fetch the default, built-in IdP Discovery Policy
data "okta_policy" "idp_discovery_policy" {
  name = "Idp Discovery Policy"
  type = "IDP_DISCOVERY"
}

# 2. Attach the Rule to the built-in policy
resource "okta_policy_rule_idp_discovery" "auth0_partners" {
  policy_id = data.okta_policy.idp_discovery_policy.id
  name      = "Route @partner.com to Auth0"
  status    = "ACTIVE"

  user_identifier_type = "IDENTIFIER"

  user_identifier_patterns {
    match_type = "SUFFIX"
    value      = "partner.com"
  }

  idp_providers {
    id   = okta_idp_oidc.auth0_ciam.id
    type = "OIDC"
  }
}