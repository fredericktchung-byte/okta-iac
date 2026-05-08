resource "okta_idp_oidc" "auth0_ciam" {
  name          = "Auth0 CIAM Tenant"
  issuer_url    = "https://dev-qx7clbs8tjgfblbp.us.auth0.com/"
  client_id     = "0wppwnB4Z77owkbPBDJ6QJXOGrAS3Bw5"
  client_secret = var.auth0_client_secret # Correct variable reference

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