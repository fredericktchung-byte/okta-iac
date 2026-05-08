# =============================================================================
# 🎯 TARGET APPLICATIONS (Phase 3)
# =============================================================================

# Oracle Cloud Infrastructure (OCI) SAML Integration
resource "okta_app_saml" "oracle_cloud" {
  label = "Oracle Cloud Infrastructure (OCI)"

  sso_url     = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"
  recipient   = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"
  destination = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"
  audience    = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"

  subject_name_id_template = "$${user.userName}"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"

  response_signed         = true
  signature_algorithm     = "RSA_SHA256"
  digest_algorithm        = "SHA256"
  honor_force_authn       = true
  authn_context_class_ref = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
}