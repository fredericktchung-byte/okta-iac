# Okta Infrastructure as Code (IaC)

This repository manages the configuration of a personal Okta Developer organization using Terraform. The goal of this project is to practice automating identity management and security posture through code.

## Project Goals
- **Eliminate ClickOps:** Ensure all configuration changes are version-controlled and reproducible.
- **Security Engineering:** Implement MFA policies, password rules, and administrative access via code.
- **Disaster Recovery:** Maintain a documented "backdoor" or emergency admin configuration to prevent lockout during aggressive security testing.

## Prerequisites
- **Okta Developer Org:** [Admin Console](https://integrator-1501452-admin.okta.com/)
- **Terraform CLI:** Installed locally.
- **Okta API Token:** Generated in the Okta Admin Console under Security > API.

## Repository Structure
- `.gitignore`: Configured to exclude sensitive Terraform state files and local variable files.
- `main.tf`: Primary Terraform configuration (to be created).
- `variables.tf`: Definitions for environment-specific variables.

## Usage
1. **Initialize:** `terraform init` to download the Okta provider.
2. **Plan:** `terraform plan` to review changes before they are applied.
3. **Apply:** `terraform apply` to push configurations to the Okta organization.

## Security Reminders
- **Never commit secrets:** Ensure `terraform.tfstate` and any `.tfvars` files containing API tokens are never pushed to this repository.
- **Backdoor Access:** Always verify that at least one administrative path (either manual or via a specific Terraform resource) exists before applying restrictive MFA or sign-on policies.
