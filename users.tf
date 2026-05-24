# Primary Admin User 
# Referenced dynamically via variables to prevent hardcoded identity lock-in.
data "okta_user" "primary_admin" {
  search {
    name  = "profile.login"
    value = var.primary_admin_email
  }
}

# Test user
resource "okta_user" "asuka_langley" {
  first_name = "Asuka"
  last_name  = "Langley"
  login      = "asuka.langley@test.local"
  email      = "asuka.langley@test.local"
  status     = "ACTIVE"
}