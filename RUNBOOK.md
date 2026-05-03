# 🛠️ Operations & Troubleshooting Runbook

This runbook outlines the day-to-day operational procedures, security guardrails, and troubleshooting steps for managing this Okta Infrastructure as Code (IaC) environment. 

## 1. ⚙️ Standard Deployment Operations

All changes to the Okta tenant must pass through a standard Terraform deployment pipeline. For manual or local runs, follow this sequence:

1. **Initialize the Environment:** Downloads the required Okta provider version.

    terraform init

2. Review the Execution Plan: Compares local code to the live Okta tenant and highlights proposed changes.

    terraform plan

3. Execute the Deployment: Applies the approved changes to the Okta tenant.

    terraform apply

## 2. 🔐 Security & Compliance Guardrails
To maintain the integrity of the Okta tenant and local development environments, the following practices are strictly enforced:

Source Control Exclusions (.gitignore): Sensitive data is explicitly blocked from the repository. This includes local terraform.tfstate files, .terraform/ directories, and .env files containing API keys.

API Token Rotation: The OKTA_API_TOKEN used for deployment is treated as a highly privileged credential. It is stored securely in GitHub Secrets for CI/CD and should be rotated every 90 days.

Separation of Duties: Direct manipulation of the Okta Admin Console is discouraged. All configuration changes should originate as Pull Requests in this repository to maintain a verifiable audit log.

## 3. 🩺 Known Issues & Troubleshooting
Pipeline / Terraform Plan Hangs Indefinitely (5+ Minutes)
Symptom: The terraform plan command freezes without throwing an immediate error.

Root Cause: Often caused by a malformed Okta API URL triggering the provider's exponential backoff/retry loop.

Resolution: Verify that the base_url variable in providers.tf is correctly populated (e.g., okta.com or oktapreview.com) and not just a trailing dot on the org name.

Git Index Lock Errors
Symptom: Git commands fail with fatal: Unable to create '.git/index.lock': File exists.

Root Cause: A previous Git process crashed or was interrupted, or a background sync engine (like OneDrive) locked the file.

Resolution: Manually remove the lock file via PowerShell:

    PowerShell
    Remove-Item -Path ".git/index.lock" -Force

"Forces Replacement" on System Apps
Symptom: Terraform attempts to destroy and recreate built-in Okta apps (like the Admin Console or Dashboard).

Root Cause: Terraform detects differences in immutable fields like type.

Resolution: Use data sources to reference system apps instead of managing them as resource blocks, or apply a lifecycle { ignore_changes = [type] } block.

## 4. 🏛️ Governance & Naming Conventions

To ensure predictable programmatic mapping, prevent namespace collisions in multi-directory environments (Okta, AD, Entra ID), and remain readable for Help Desk operations, all managed Okta resources MUST adhere to this prefix-based hybrid naming convention:

* **Departments:** `[Source] - Dept - [Plain English]` (e.g., `Okta - Dept - Engineering`)
* **Privileged Roles:** `[Source] - Role - [Plain English]` (e.g., `Okta - Role - IT Super Admin`)
* **Application Access:** `[Source] - App - [App] - [Access Level]` (e.g., `AD - App - Salesforce - Standard User`)
* **Service Accounts:** `SVC - [System Name]` (e.g., `SVC - GitHub Actions`)

*Note: Terraform resource identifiers (the name used in the `.tf` file) remain concise (e.g., `resource "okta_group" "engineering"`). Mandatory descriptions serve as the final safety net for manual operations.*