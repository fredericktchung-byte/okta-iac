# 1. The Built-in "Everyone" Group 
# This group is automatically created by Okta and includes all users in the organization.
# It's a critical component for baseline access policies and should be referenced but not managed by Terraform.
data "okta_everyone_group" "everyone" {}

# Workato application assignment group
resource "okta_group" "app_workato_users" {
  name        = "App - Workato - Users"
  description = "Group for users assigned to the Workato application"
}

# Tines application assignment group
resource "okta_group" "app_tines_users" {
  name        = "App - Tines - Users"
  description = "Group for users assigned to the Tines application"
}

resource "okta_group" "engineering" {
  name        = "Okta - Dept - Engineering"
  description = "Auto-assigned: Base access for all Engineering staff. Mastered in Okta via Terraform."
}

# This group is for the Okta Super Admin role, which has full access to all features and settings in Okta.
resource "okta_group" "super_admins" {
  name        = "Okta - Role - IT Super Admin"
  description = "WARNING: Grants Okta Super Admin privileges. Mastered in Okta via Terraform."
}

# Salesforce outbound provisioning application assignment group
resource "okta_group" "app_salesforce_provisioning_users" {
  custom_profile_attributes = jsonencode({})
  description               = "Assigns outbound provisioning access to Salesforce"
  name                      = "App - Salesforce Outbound Provisioning - Users"
}

# Salesforce inbound provisioning application assignment group
resource "okta_group" "app_salesforce_inbound_provisioning_users" {
  custom_profile_attributes = jsonencode({})
  description               = "Assigns inbound provisioning access from Salesforce"
  name                      = "App - Salesforce Inbound Provisioning - Users"
}