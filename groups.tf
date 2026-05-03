# ============================================================================
# 👥 GROUP DEFINITIONS
# ============================================================================
# This file defines user groups used for policy scoping and access control.
# Built-in Okta groups (Everyone, Administrators) are referenced but not managed here.
resource "okta_group" "engineering" {
  name        = "Engineering"
  description = "Standard group for all Engineering staff"
}

resource "okta_group" "role_super_administrators" {
  name        = "Role - Super Administrators"
  description = "Okta Super Administrators"
}

resource "okta_group" "role_service_accounts" {
  name        = "Role - Service Accounts"
  description = "Managed service accounts for automation"
}

# Note: These are built-in Okta groups
resource "okta_group" "everyone" {
  name        = "Everyone"
  description = "All users in your organization"
  # Okta manages membership automatically
}

resource "okta_group" "okta_administrators" {
  name        = "Okta Administrators"
  description = "Okta manages this group, which contains all administrators in your organization."
}