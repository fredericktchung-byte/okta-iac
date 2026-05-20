# =============================================================================
# 👥 IDENTITY SOURCES (Phase 1: Foundation)
# =============================================================================

# --- DATA SOURCES (Read-Only) ---

# 1. The Built-in "Everyone" Group 
# This group is automatically created by Okta and includes all users in the organization.
# It's a critical component for baseline access policies and should be referenced but not managed by Terraform.
data "okta_everyone_group" "everyone" {}

# 2. Your Primary Admin User 
# Referenced dynamically via variables to prevent hardcoded identity lock-in.
data "okta_user" "primary_admin" {
  search {
    name  = "profile.login"
    value = var.primary_admin_email
  }
}

# --- RESOURCES (Managed by Terraform) ---

# 3. Core Organizational Groups (Multi-Directory Naming Convention)
resource "okta_group" "engineering" {
  name        = "Okta - Dept - Engineering"
  description = "Auto-assigned: Base access for all Engineering staff. Mastered in Okta via Terraform."
}

resource "okta_group" "super_admins" {
  name        = "Okta - Role - IT Super Admin"
  description = "WARNING: Grants Okta Super Admin privileges. Mastered in Okta via Terraform."
}

# 4. A Test User (For validating policies in Phase 2)
resource "okta_user" "asuka_langley" {
  first_name = "Asuka"
  last_name  = "Langley"
  login      = "asuka.langley@test.local"
  email      = "asuka.langley@test.local"
  status     = "ACTIVE"
}