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

# Atlassian application assignment group
resource "okta_group" "app_atlassian_users" {
  name        = "App - Atlassian - Users"
  description = "Group for users assigned to Atlassian applications like Jira and Confluence"
}
# Confluence admin group
resource "okta_group" "confluence_admins" {
  name        = "App - Confluence - Admins"
  description = "Group for users with admin access to Confluence"
}

# Confluence contractor group
resource "okta_group" "confluence_contractors" {
  name        = "App - Confluence - Contractors"
  description = "Group for users with contractor access to Confluence"
}

# Jira application assignment group
resource "okta_group" "jira_users" {
  name        = "App - Jira - Users"
  description = "Group for users assigned to the Jira application"
}

# Autodesk Platform Services application assignment group
resource "okta_group" "app_autodesk_users" {
  name        = "App - Autodesk Platform Services - Users"
  description = "Group for users assigned to the Autodesk Platform Services application"
}

# Github application assignment group
resource "okta_group" "app_github_users" {
  name        = "App - Github - Users"
  description = "Group for users assigned to the Github application"
}

# Slack application assignment group
resource "okta_group" "app_slack_users" {
  name        = "App - Slack - Users"
  description = "Group for users assigned to the Slack application"
}

# Databricks application assignment group
resource "okta_group" "app_databricks_users" {
  name        = "App - Databricks - Users"
  description = "Group for users assigned to the Databricks application"
}

# HubSpot application assignment group
resource "okta_group" "app_hubspot_users" {
  name        = "App - HubSpot - Users"
  description = "Group for users assigned to the HubSpot application"
}

# AirTable application assignment group
resource "okta_group" "app_airtable_users" {
  name        = "App - AirTable - Users"
  description = "Group for users assigned to the AirTable application"
}

# Bitwarden application assignment group
resource "okta_group" "app_bitwarden_users" {
  name        = "App - Bitwarden - Users"
  description = "Group for users assigned to the Bitwarden application"
}

# Grafana Admin application assignment group
resource "okta_group" "app_grafana_admins" {
  name        = "App - Grafana - Admins"
  description = "Group for users with admin access to Grafana"
}

# Grafana Editors application assignment group
resource "okta_group" "app_grafana_editors" {
  name        = "App - Grafana - Editors"
  description = "Group for users with editor access to Grafana"
}

# Grafana Viewers application assignment group
resource "okta_group" "app_grafana_viewers" {
  name        = "App - Grafana - Viewers"
  description = "Group for users with viewer access to Grafana"
}

# Notion application assignment group
resource "okta_group" "app_notion_users" {
  name        = "App - Notion - Users"
  description = "Group for users assigned to the Notion bookmarkapplication"
}

# Figma application assignment group
resource "okta_group" "app_figma_users" {
  name        = "App - Figma - Users"
  description = "Group for users assigned to the Figma application"
}

# Google Cloud Platform application assignment group
resource "okta_group" "app_gcp_users" {
  name        = "App - Google Cloud Platform - Users"
  description = "Group for users assigned to the Google Cloud Platform application"
}

# Zapier application assignment group
resource "okta_group" "app_zapier_users" {
  name        = "App - Zapier - Users"
  description = "Group for users assigned to the Zapier application"
}

# Canvas application assignment group
resource "okta_group" "app_canvas_users" {
  name        = "App - Canvas - Users"
  description = "Group for users assigned to the Canvas bookmark application"
}
