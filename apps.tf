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