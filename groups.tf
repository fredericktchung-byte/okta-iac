# Workato application assignment group
resource "okta_group" "app_workato_users" {
  name        = "App - Workato - Users"
  description = "Group for users assigned to the Workato application"
}