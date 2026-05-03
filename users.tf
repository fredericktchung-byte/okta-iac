# ============================================================================
# 👤 TEST USERS
# ============================================================================
# This file contains test user accounts used for development and testing.
# These are not required for production operation.
resource "okta_user" "test_engineer" {
  first_name = "Test"
  last_name  = "Engineer"
  login      = "test.engineer@example.com"
  email      = "test.engineer@example.com"
}