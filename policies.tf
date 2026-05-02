resource "okta_policy_signon" "default" {
  name            = "Default Policy"
  status          = "ACTIVE"
  description     = "The default policy applies in all situations if no other policy applies."
  groups_included = [data.okta_everyone_group.everyone.id]
}