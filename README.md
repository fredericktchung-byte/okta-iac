# 🔐 Identity as Code (IaC): Okta Enterprise Deployment

This repository contains the Infrastructure as Code (IaC) configurations for managing an enterprise-grade Okta tenant for `poutine-lab.com`. It utilizes **Terraform** and the official Okta Provider to automate the deployment of users, security policies, and application integrations in a predictable, version-controlled manner.

## 🏗️ GitOps Architecture & CI/CD Pipeline

This repository acts as the absolute single source of truth for the Okta environment, utilizing a strict GitOps continuous deployment model.

* **Continuous Integration (CI):** Pull requests opened against the `main` branch trigger `.github/workflows/tf-plan.yml`. This workflow securely authenticates to the OCI backend, runs validation and formatting checks, and automatically posts the `terraform plan` output directly to the PR comments for peer review.
* **Continuous Deployment (CD):** Upon PR approval and merge, `.github/workflows/tf-apply.yml` automatically triggers, executing `terraform apply` to provision the exact approved configuration to the Okta tenant.
* **State Management:** Terraform state is stored securely in an Oracle Cloud Infrastructure (OCI) backend (`okta-iac-terraform-state` in `us-sanjose-1`) with state locking enabled to prevent pipeline conflicts.

### Security Controls & Variables
To balance GitOps visibility with strict security, variables are managed via a hybrid approach:
1. **GitHub Secrets:** Highly sensitive credentials (e.g., `OKTA_API_TOKEN`, `AUTH0_CLIENT_SECRET`, OCI keys, JWKS components) are stored in repository secrets and injected into the GitHub Actions runners at runtime via `TF_VAR_` prefixes.
2. **Plaintext Configuration:** Non-sensitive environment variables (e.g., domain names, admin emails) are tracked in `config.auto.tfvars`.
*(Note: A `.gitignore` policy strictly prevents any other `*.tfvars` files from being committed).*

---

## 🚀 Deployment Methodology

This architecture follows a phased deployment strategy to ensure a secure, zero-friction rollout.

### Phase 1: The Foundation (Identity Sources)
* **Objective:** Define the "Who."
* **Components:** Core Groups, Group Rules, Custom Profile Attributes, and Directory Integrations.
* **Files:** `identity_sources.tf`

### Phase 2: The Perimeter (Security & Authentication)
* **Objective:** Define the "How."
* **Components:** Network Zones, Authenticators (WebAuthn, Okta Verify), Global Session Policies, MFA Enrollment, and IdP Routing.
* **Files:** `security_perimeter.tf`, `policies_global.tf`, `policies_enrollment.tf`, `identity_providers.tf`
* *Note:* The Proxy & VPN Zone in `security_perimeter.tf` blocks access from non-commercial VPNs and anonymizers, excluding iCloud Private Relay, to reduce the attack surface.

### Phase 3: The Payload (Applications)
* **Objective:** Define the "What."
* **Components:** SAML/OIDC Application definitions, Zero-Trust App Sign-On Policies (Passwordless), and Group assignments.
* **Files:** `apps.tf`, `policies_authentication.tf`

### Phase 4: The Engine (Lifecycle & Automation)
* **Objective:** Define the "When."
* **Components:** Event Hooks, Inline Hooks, and automated provisioning rules (SCIM).
* **Files:** `automation.tf`

---

## 🧑‍💻 Local Development

Because the CI/CD pipeline enforces formatting and state consistency, use these commands before opening a pull request to keep local changes aligned:

```bash
terraform fmt -recursive .
terraform validate