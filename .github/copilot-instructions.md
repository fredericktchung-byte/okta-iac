# Copilot Instructions for okta-iac

## Project Overview
- This repository manages Okta organization configuration using Terraform, enabling reproducible, version-controlled identity and security management.
- All Okta resources (users, groups, policies) are defined as Terraform resources in `.tf` files.
- The main goal is to eliminate manual configuration ("ClickOps") and enforce security best practices (MFA, password policies, disaster recovery).

## Key Files & Structure
- `main.tf`: Provider configuration and entry point for Okta setup.
- `variables.tf`: Declares required variables (e.g., `org_name`, `base_url`, `api_token`).
- `users.tf`, `groups.tf`: Define Okta users and groups as Terraform resources.
- `secrets.tfvars`, `terraform.tfvars`: Store sensitive values (never commit these).
- `.gitignore`: Excludes all state, secrets, and override files from version control.

## Developer Workflow
- **Initialize:** `terraform init` (downloads Okta provider)
- **Plan:** `terraform plan` (shows pending changes)
- **Apply:** `terraform apply` (applies changes to Okta)
- Always verify a backdoor admin path exists before applying restrictive policies.
- Never commit `.tfstate` or `.tfvars` files.

## Patterns & Conventions
- Each Okta entity (user, group, etc.) is a separate Terraform resource block.
- Use variable references for sensitive data (see `variables.tf`).
- Group memberships are managed via `okta_group_memberships` resources.
- Provider version is pinned in `main.tf` for reproducibility.
- Sensitive variables are marked with `sensitive = true`.

## Integration Points
- Relies on the [Okta Terraform Provider](https://registry.terraform.io/providers/okta/okta/latest).
- Requires an Okta API token (see README for generation steps).

## Security Practices
- All secrets and state files are excluded from git.
- Disaster recovery: Always maintain an admin path to avoid lockout.

## Example: Adding a New User
1. Add a new `okta_user` resource in `users.tf`.
2. Add the user to a group via `okta_group_memberships` in `groups.tf`.
3. Run `terraform plan` and `terraform apply`.

Refer to `README.md` for more context and Okta org details.
