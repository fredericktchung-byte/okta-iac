# Infrastructure as Code (IaC) Guidelines

## Managing Okta OIN Apps (`okta_app_saml`)
Pre-configured apps from the Okta Integration Network bundle their API credentials and backend toggles into a single JSON payload (`app_settings_json`). 

Running `terraform apply` on an environment where the OAuth API connection was established manually in the Okta UI will attempt to destroy the connection, as Terraform will read the `scimOAuthClientSecret` from the live state but not the `.tf` file.

**Required `lifecycle` Block:**
All `okta_app_saml` resources that handle API provisioning MUST include the following lifecycle block to prevent state destruction:

```hcl
  lifecycle {
    ignore_changes = [
      app_settings_json
    ]
  }