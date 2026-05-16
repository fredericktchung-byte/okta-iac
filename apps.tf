# =============================================================================
# 🎯 TARGET APPLICATIONS (Phase 3)
# =============================================================================

# Oracle Cloud Infrastructure (OCI) SAML Integration
resource "okta_app_saml" "oracle_cloud" {
  label = "Oracle Cloud Infrastructure (OCI)"

  # The SSO Destination Endpoints
  sso_url     = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"
  recipient   = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"
  destination = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"

  # The strict Entity ID / Provider ID expected by Oracle
  audience = "https://${var.oci_domain_id}.identity.oraclecloud.com:443/fed"

  # OCI requires the NameID to be the email address, mapped precisely
  subject_name_id_template = "$${user.email}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

  response_signed         = true
  signature_algorithm     = "RSA_SHA256"
  digest_algorithm        = "SHA256"
  honor_force_authn       = true
  authn_context_class_ref = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
}

# Workato SAML Integration
resource "okta_app_saml" "workato" {
  label             = "Workato"
  preconfigured_app = "workato"

  # Because it's an OIN app, Okta automatically populates the SSO URLs, 
  # Audience Restrictions, and standard Attribute Statements for you!
}

# =============================================================================
# 🤖 MACHINE-TO-MACHINE (Phase 3 -> Phase 4 Bridge)
# =============================================================================

# Workato API Access Application (OIDC / Client Credentials)
resource "okta_app_oauth" "workato_m2m" {
  label       = "Workato API Integration"
  type        = "service"
  grant_types = ["client_credentials"]

  # Enforcing high-security cryptographic authentication
  token_endpoint_auth_method = "private_key_jwt"

  # Injecting the Public Key for Okta to verify Workato's signature
  jwks {
    kty = "RSA"
    kid = "5IzcQecwWliLbmPGx9bVD7UTYgIx/ulP9jYW4BQRGe0=" # A unique identifier we make up
    e   = "AQAB"
    n   = "0f1NLP5rqh9HhEcopXri0OcUaTKy65U6y5JaKfRZ4vniEPK8WlPDJOCxCZZ-VSYT439VsFEM-DUyFiG7CdX5G-JijFF2AeIZ5k1CDo8rn_e-cBN-0-PjKFvV-xGA4If1QckyCKSMLp2hcAUUqzrVa1W5hf-8dHV3YAp4DOU4eyb5rUcncBX0MH3w0ashOjG7vdYz0xAsfGVwjjgyg5QS9rAdwDR5gyj6OGr7Jni7WMy6a-er34ZMfgdSDc65SVr7Sxr_MRlRdZW-ZNINfvCEWhVYKhVWw0Gk9sn4kL5mgvnztiTVPMrBGDETJUF6GUol3afZiTfKDunskcgQSExKyQ"
  }
}

# Authorize the M2M App to manage Okta Directory components
resource "okta_app_oauth_api_scope" "workato_scopes" {
  app_id = okta_app_oauth.workato_m2m.id
  issuer = "https://integrator-1501452.okta.com"
  scopes = [
    "okta.users.manage",
    "okta.groups.manage",
    "okta.schemas.read",
    "okta.logs.read",
    "okta.eventHooks.manage",
    "okta.apps.read"
  ]
}