# =============================================================================
# 🎯 TARGET APPLICATIONS
# =============================================================================

# Oracle Cloud Infrastructure (OCI) SAML Integration
resource "okta_app_saml" "oracle_cloud" {
  label = "Oracle Cloud Infrastructure (OCI)"
  # Binds this specific app to the Zero-Trust Phishing Resistant policy
  authentication_policy = okta_app_signon_policy.passwordless.id # The SSO Destination Endpoints
  sso_url               = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"
  recipient             = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"
  destination           = "https://${var.oci_domain_id}.identity.oraclecloud.com/fed/v1/sp/sso"

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
  # Binds this specific app to the Zero-Trust Phishing Resistant policy
  authentication_policy = okta_app_signon_policy.passwordless.id
  # Because it's an OIN app, Okta automatically populates the SSO URLs, 
  # Audience Restrictions, and standard Attribute Statements for you!
}

# Atlassian Bookmark Integration
resource "okta_app_bookmark" "atlassian" {
  label                 = "Atlassian"
  authentication_policy = okta_app_signon_policy.bookmark_apps.id # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
  url                   = "https://fredericktchung.atlassian.net" # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
}

# Atlassian application group assignment
resource "okta_app_group_assignment" "atlassian_users" {
  app_id   = okta_app_bookmark.atlassian.id
  group_id = okta_group.app_atlassian_users.id
}

# Jira Bookmark Integration
resource "okta_app_bookmark" "jira" {
  label                 = "Jira"
  authentication_policy = okta_app_signon_policy.bookmark_apps.id      # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
  url                   = "https://fredericktchung.atlassian.net/jira" # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
}

# Jira application group assignment
resource "okta_app_group_assignment" "jira_users" {
  app_id   = okta_app_bookmark.jira.id
  group_id = okta_group.jira_users.id
}

# Confluence Bookmark Integration
resource "okta_app_bookmark" "confluence" {
  label = "Confluence"
  url   = "https://fredericktchung.atlassian.net/wiki" # Update with your domain

  # Bind the app to our new relaxed authentication policy
  authentication_policy = okta_app_signon_policy.bookmark_apps.id
}

# Assign the app to your Administrator group
resource "okta_app_group_assignment" "confluence_admins" {
  app_id   = okta_app_bookmark.confluence.id
  group_id = okta_group.confluence_admins.id # Ensure this matches your admin group resource name
}

# Assign the app to your Contractor group
resource "okta_app_group_assignment" "confluence_contractors" {
  app_id   = okta_app_bookmark.confluence.id
  group_id = okta_group.confluence_contractors.id # Ensure this matches your contractor group resource name
}

# Autodesk Platform Services Bookmark Integration
resource "okta_app_bookmark" "autodesk" {
  label                 = "Autodesk Platform Services"
  url                   = "https://aps.autodesk.com"
  authentication_policy = okta_app_signon_policy.bookmark_apps.id # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.

}

# Autodesk Platform Services application group assignment
resource "okta_app_group_assignment" "autodesk_users" {
  app_id   = okta_app_bookmark.autodesk.id
  group_id = okta_group.app_autodesk_users.id
}

# Salesforce SAML Integration for SSO only (not provisioning)
# Salesforce's SAML configuration is notoriously complex and often requires custom attribute mappings and specific settings that may not be fully supported by the standard Okta SAML app. We onboard the application in the UI then import it into Terraform to manage the more intricate configurations that are necessary for a successful integration. This allows us to leverage Terraform's state management while accommodating Salesforce's unique requirements.
resource "okta_app_saml" "salesforce" {
  label             = "Salesforce"
  preconfigured_app = "salesforce"
  # Binds this specific app to the Zero-Trust Phishing Resistant policy
  authentication_policy = okta_app_signon_policy.passwordless.id
  # Salesforce requires the NameID to be the Salesforce User ID, which is a custom attribute we need to map from Okta. This is a common point of failure in Salesforce SAML integrations, so we need to ensure it's configured correctly.
  user_name_template      = "user.salesforceId"
  user_name_template_type = "CUSTOM"
  app_settings_json = jsonencode({
    instanceType    = "PRODUCTION"
    integrationType = "STANDARD"
    loginUrl        = "https://orgfarm-4cab0d731f-dev-ed.develop.my.salesforce.com"
    logoutUrl       = "https://orgfarm-4cab0d731f-dev-ed.develop.my.salesforce.com/services/auth/sp/saml2/logout"
  })
}

# Salesforce outbound provisioning integration (SCIM) for users mastered by Okta but need access to Salesforce. This is a separate app from the SAML SSO integration because it serves a different purpose and may require different configurations. By creating a separate app for outbound provisioning, we can ensure that users who are mastered in Okta can be provisioned into Salesforce with the appropriate attributes and group memberships, while still managing it through Terraform.
resource "okta_app_saml" "salesforce_provisioning" {
  label                 = "Salesforce SCIM Outbound Provisioning"
  preconfigured_app     = "salesforce"
  authentication_policy = okta_app_signon_policy.passwordless.id
  hide_web              = true # Hides the app from users since it's only for provisioning
  hide_ios              = true # This app is only for provisioning, so we don't bind it to the authentication policy
  app_settings_json = jsonencode({
    scimBaseUrl     = "https://orgfarm-4cab0d731f-dev-ed.develop.my.salesforce.com/services/scim/v2"
    scimAuthType    = "OAUTH2"
    instanceType    = "PRODUCTION"
    integrationType = "STANDARD"
  })
  lifecycle {
    ignore_changes = [
      app_settings_json
    ]
  }
}

# Salesforce inbound provisioning integration (SCIM) for users mastered by Salesforce but still need access to Okta-managed resources. This is a separate app from the SAML SSO integration because it serves a different purpose and may require different configurations. By creating a separate app for inbound provisioning, we can ensure that users who are mastered in Salesforce can be provisioned into Okta with the appropriate attributes and group memberships, while still managing it through Terraform.
resource "okta_app_saml" "salesforce_inbound_provisioning" {
  label                 = "Salesforce SCIM Inbound Provisioning"
  preconfigured_app     = "salesforce"
  authentication_policy = okta_app_signon_policy.passwordless.id
  hide_ios              = true # Hides the app from users since it's only for provisioning
  hide_web              = true # Hides the app from users since it's only for provisioning
  # This app is only for provisioning, so we don't bind it to the authentication policy
  app_settings_json = jsonencode({
    scimBaseUrl     = "https://orgfarm-4cab0d731f-dev-ed.develop.my.salesforce.com/services/scim/v2"
    scimAuthType    = "OAUTH2"
    instanceType    = "PRODUCTION"
    integrationType = "STANDARD"
  })
  lifecycle {
    ignore_changes = [
      app_settings_json
    ]
  }
}

# Tines SAML Integration
resource "okta_app_saml" "tines" {
  label             = "Tines"
  preconfigured_app = "tinescom"
  # Binds this specific app to the Zero-Trust Phishing Resistant policy
  authentication_policy = okta_app_signon_policy.passwordless.id
  app_settings_json = jsonencode({
    tenantUrl = "https://lingering-dream-8343.tines.com" }
  )
}


# =============================================================================
# 🤖 MACHINE-TO-MACHINE (Phase 3 -> Phase 4 Bridge)
# =============================================================================

# Workato API Access Application (OIDC / Client Credentials)
resource "okta_app_oauth" "workato_m2m" {
  label       = "Workato API Integration"
  type        = "service"
  grant_types = ["client_credentials"]
  issuer_mode = "DYNAMIC"

  # Enforcing high-security cryptographic authentication
  token_endpoint_auth_method = "private_key_jwt"

  # Injecting the Public Key for Okta to verify Workato's signature
  jwks {
    kty = "RSA"
    kid = "5IzcQecwWliLbmPGx9bVD7UTYgIx/ulP9jYW4BQRGe0=" # A unique identifier we make up
    e   = var.workato_jwks_e
    n   = var.workato_jwks_n
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

# Tines API Access Application (OIDC / Client Credentials)
resource "okta_app_oauth" "tines_m2m" {
  label       = "Tines API Integration"
  type        = "service"
  grant_types = ["client_credentials"]
  issuer_mode = "DYNAMIC"

  # Enforcing high-security cryptographic authentication
  token_endpoint_auth_method = "private_key_jwt"

  # Injecting the Public Key for Okta to verify Tines' signature
  jwks {
    kid = "tines-key-1" # A unique identifier we make up
    kty = "RSA"
    n   = var.tines_jwks_n
    e   = var.tines_jwks_e
  }
}

# Authorize the M2M App to manage Okta Directory components
resource "okta_app_oauth_api_scope" "tines_scopes" {
  app_id = okta_app_oauth.tines_m2m.id
  issuer = "https://integrator-1501452.okta.com"
  scopes = [
    "okta.users.manage",
    "okta.groups.manage",
    "okta.schemas.read",
    "okta.logs.read",
    "okta.eventHooks.manage",
    "okta.apps.read",
    "okta.networkZones.manage",
    "okta.networkZones.read"
  ]
}

# Github Bookmark Integration
resource "okta_app_bookmark" "github" {
  label                 = "GitHub"
  url                   = "https://github.com/fredericktchung-byte" # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id   # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# GitHub application group assignment
resource "okta_app_group_assignment" "github_users" {
  app_id   = okta_app_bookmark.github.id
  group_id = okta_group.app_github_users.id
}

# Slack bookmark integration
resource "okta_app_bookmark" "slack" {
  label                 = "Slack"
  url                   = "https://app.slack.com/client/T0B4NR1TY7L" # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id    # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# Slack application group assignment
resource "okta_app_group_assignment" "slack_users" {
  app_id   = okta_app_bookmark.slack.id
  group_id = okta_group.app_slack_users.id
}

# Databricks SAML Integration
resource "okta_app_saml" "databricks" {
  label             = "Databricks"
  preconfigured_app = "databricks"
  # Binds this specific app to the Zero-Trust Phishing Resistant policy
  authentication_policy = okta_app_signon_policy.passwordless.id
  app_settings_json = jsonencode({
    databricksSamlUrl = "https://dbc-7c4fe004-0fdd.cloud.databricks.com/saml/consume" }
  )
}

# Databricks application group assignment
resource "okta_app_group_assignment" "databricks_users" {
  app_id   = okta_app_saml.databricks.id
  group_id = okta_group.app_databricks_users.id
}

# HubSpot Bookmark Integration
resource "okta_app_bookmark" "hubspot" {
  label                 = "HubSpot"
  url                   = "https://app-na2.hubspot.com/global-home/246304908" # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id             # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# AirTable Bookmark Integration
resource "okta_app_bookmark" "airtable" {
  label                 = "AirTable"
  url                   = "https://airtable.com"                  # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# AirTable application group assignment
resource "okta_app_group_assignment" "airtable_users" {
  app_id   = okta_app_bookmark.airtable.id
  group_id = okta_group.app_airtable_users.id
}

# Bitwarden Bookmark Integration
resource "okta_app_bookmark" "bitwarden" {
  label                 = "Bitwarden"
  url                   = "https://vault.bitwarden.com"           # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# Bitwarden application group assignment
resource "okta_app_group_assignment" "bitwarden_users" {
  app_id   = okta_app_bookmark.bitwarden.id
  group_id = okta_group.app_bitwarden_users.id
}

# Grafana OIDC Integration
resource "okta_app_oauth" "grafana" {
  authentication_policy = okta_app_signon_policy.passwordless.id # Binds this specific app to the Zero-Trust Phishing Resistant policy
  client_id             = "0oa13lds0aqH7ZH1X698"
  label                 = "Grafana"
  post_logout_redirect_uris = [
    "https://fredericktchungbyte.grafana.net/logout",
  ]
  profile = null
  redirect_uris = [
    "https://fredericktchungbyte.grafana.net/login/okta",
  ]
  refresh_token_rotation = "STATIC"
  response_types = [
    "code",
  ]
  status                     = "ACTIVE"
  token_endpoint_auth_method = "client_secret_basic"
  type                       = "web"
  hide_web                   = false
  login_mode                 = "SPEC"
  login_uri                  = "https://fredericktchungbyte.grafana.net/login"
  issuer_mode                = "DYNAMIC"
  groups_claim {
    filter_type = "REGEX"
    name        = "groups"
    type        = "FILTER"
    value       = ".*"
  }
}

# Grafana Admins application group assignment
resource "okta_app_group_assignment" "grafana_admins" {
  app_id   = okta_app_oauth.grafana.id
  group_id = okta_group.app_grafana_admins.id
}

# Grafana Editors application group assignment
resource "okta_app_group_assignment" "grafana_editors" {
  app_id   = okta_app_oauth.grafana.id
  group_id = okta_group.app_grafana_editors.id
}

# Grafana Viewers application group assignment
resource "okta_app_group_assignment" "grafana_viewers" {
  app_id   = okta_app_oauth.grafana.id
  group_id = okta_group.app_grafana_viewers.id
}

# Notion bookmark integration
resource "okta_app_bookmark" "notion" {
  label                 = "Notion"
  url                   = "https://app.notion.com/p/Welcome-to-Notion-37201dd05b8280d8b475ea3294aeda36" # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id                                       # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# Notion application group assignment
resource "okta_app_group_assignment" "notion_users" {
  app_id   = okta_app_bookmark.notion.id
  group_id = okta_group.app_notion_users.id
}

# Figma bookmark integration
resource "okta_app_bookmark" "figma" {
  label                 = "Figma"
  url                   = "https://www.figma.com/files/recent"    # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# Figma application group assignment
resource "okta_app_group_assignment" "figma_users" {
  app_id   = okta_app_bookmark.figma.id
  group_id = okta_group.app_figma_users.id
}

# Zapier bookmark integration
resource "okta_app_bookmark" "zapier" {
  label                 = "Zapier"
  url                   = "https://zapier.com/app/dashboard"      # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# Zapier application group assignment
resource "okta_app_group_assignment" "zapier_users" {
  app_id   = okta_app_bookmark.zapier.id
  group_id = okta_group.app_zapier_users.id
}

# Canva bookmark integration
resource "okta_app_bookmark" "canva" {
  label                 = "Canva"
  url                   = "https://www.canva.com/design"          # This is the URL users will be directed to when they click the bookmark in Okta. It can be the generic login page since our authentication policy will allow access with an active session, preventing double prompts.
  authentication_policy = okta_app_signon_policy.bookmark_apps.id # Binds the bookmark app to the relaxed policy that allows access with an active session, preventing double prompts for users who are already authenticated to Okta.
}

# Canva application group assignment
resource "okta_app_group_assignment" "canva_users" {
  app_id   = okta_app_bookmark.canva.id
  group_id = okta_group.app_canva_users.id
}

# Cloudflare OIDC Integration
resource "okta_app_oauth" "cloudflare" {
  label = "Cloudflare One"

  # Satisfies the provider's requirement for the schema
  type = "web"

  # Restores the OIN-specific settings that were about to be deleted
  app_settings_json = jsonencode({
    app = {
      team_domain = "dry-violet-c576"
    }
    manualProvisioning = false
  })

  # Instructs Terraform to ignore the type mismatch between the code and the state,
  # preventing the ForceNew destruction of the application.
  lifecycle {
    ignore_changes = [
      type
    ]
  }
}

# Cloudflare application group assignment
resource "okta_app_group_assignment" "cloudflare_users" {
  app_id   = okta_app_oauth.cloudflare.id
  group_id = okta_group.app_cloudflare_users.id
}

# Cloudflare SCIM Integration
resource "okta_app_saml" "cloudflare_scim" {
  label                 = "Cloudflare SCIM"
  authentication_policy = okta_app_signon_policy.passwordless.id # Binds this specific app to the Zero-Trust Phishing Resistant policy
  hide_web              = true                                   # Hides the app from users since it's only for provisioning  
  hide_ios              = true                                   # Hides the app from users since it's only for provisioning
}

# Cloudflare SCIM application group assignment. Uses the same group assigned to the Oauth Cloudflare One app.
resource "okta_app_group_assignment" "cloudflare_scim_users" {
  app_id   = okta_app_saml.cloudflare_scim.id
  group_id = okta_group.app_cloudflare_users.id
}
