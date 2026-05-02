resource "okta_user" "test_engineer" {
  first_name = "Test"
  last_name  = "Engineer"
  login      = "test.engineer@example.com"
  email      = "test.engineer@example.com"
}