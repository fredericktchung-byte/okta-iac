# 🔐 Identity as Code (IaC): Okta Enterprise Deployment

This repository contains the Infrastructure as Code (IaC) configurations for managing an enterprise-grade Okta tenant. It utilizes **Terraform** and the official Okta Provider to automate the deployment of users, security policies, and application integrations in a predictable, version-controlled manner.

## 🏗️ Deployment Methodology

This architecture follows a phased deployment strategy to ensure a secure, zero-friction rollout. The repository structure mirrors these phases to maintain clear separation of duties and simplify security audits.

### Phase 1: The Foundation (Identity Sources)
* **Objective:** Define the "Who."
* **Components:** Core Groups, Group Rules, Custom Profile Attributes, and Directory Integrations.
* **Files:** `identity_sources.tf`

## Phase 2: The Perimeter (Security & Authentication)
- **Objective:** Define the "How."
- **Components:** Network Zones, Authenticators (WebAuthn, Okta Verify), Global Session Policies, MFA Enrollment, and IdP Routing.
- **Files:** `security_perimeter.tf`, `policies_global.tf`, `policies_enrollment.tf`, `identity_providers.tf`
  > **Note:** The Proxy & VPN Zone in `security_perimeter.tf` blocks access from non-commercial VPNs and anonymizers, excluding iCloud Private Relay, to reduce the attack surface. iCloud Private Relay is set as an exception to allow Apple devices to authenticate correctly.

## Phase 3: The Payload (Applications)
- **Objective:** Define the "What."
- **Components:** SAML/OIDC Application definitions, Zero-Trust App Sign-On Policies (Passwordless), and Group assignments.
- **Files:** `apps.tf`, `policies_authentication.tf`

## 🚦 GitHub Branch Protection and CI Governance
This repository is governed by a branch protection policy implemented as part of Jira issue **OKTA-18**.
- `main` is protected and changes must be made through pull requests.
- Pull requests require the GitHub Actions workflow in `.github/workflows/terraform-validate.yml` to pass.
- This workflow validates `terraform fmt -recursive .` and `terraform validate` for all `.tf` changes.
- The policy is designed to enforce review, maintain Terraform formatting, and prevent direct merges to the protected branch.

## 🧑‍💻 Local Development
Use these commands before opening a pull request to keep local changes aligned with CI expectations:
```bash
terraform fmt -recursive .
terraform init -backend=false
terraform validate
```
- Confirm your `TF_VAR_api_token` or equivalent environment variable is set before running Terraform.
- For full backend usage, configure OCI credentials and run `terraform init` without `-backend=false` when working against the shared state.

## 🌐 Terraform State Backend
The Terraform configuration is anchored to a remote OCI backend in `providers.tf`:
- OCI bucket: `okta-iac-terraform-state`
- Region: `us-sanjose-1`
- State key: `prod/terraform.tfstate`

This ensures shared state management and reduces the risk of local-state drift.

### Phase 4: The Engine (Lifecycle & Automation)
* **Objective:** Define the "When."
* **Components:** Event Hooks, Inline Hooks, and automated provisioning rules (SCIM).
* **Files:** `automation.tf`

### Phase 5: Multi-Cloud Identity Federation (Roadmap)
* **Objective:** Establish Okta as the central Identity Hub across multiple isolated cloud environments.
* **Target Integrations:** * Oracle Cloud Infrastructure (OCI) via SAML/OIDC.
  * Microsoft Entra ID (Developer Tenant) directory federation.

### Phase 6: Advanced Governance & Privileged Access (Roadmap)
* **Objective:** Implement Zero-Trust principles for infrastructure management.
* **Target Architecture:**
  * **Just-In-Time (JIT) Administration:** Transitioning from static Okta admin roles to dynamic, time-bound privilege elevation.
  * **GitOps Maturation:** Hardening the GitHub Actions pipeline for secure token lifecycle management and automated state reconciliation without human credential exposure.
---

## 📂 Repository Structure

To maintain a "scannable" and modular codebase, configurations are logically separated rather than grouped into a single monolithic state:

```text
├── .github/workflows/       # CI/CD pipelines for plan/apply
├── providers.tf             # Okta provider configuration and version pinning
├── variables.tf             # Core inputs (org_name, base_url, etc.)
├── identity_sources.tf      # Phase 1: Groups and users
├── security_perimeter.tf    # Phase 2: Network zones and authenticators
├── policies_global.tf       # Phase 2: Global sign-on policies
├── ...                      # (Additional phase files)
└── RUNBOOK.md               # Operational procedures and troubleshooting