# 🔐 Identity as Code (IaC): Okta Enterprise Deployment

This repository contains the Infrastructure as Code (IaC) configurations for managing an enterprise-grade Okta tenant. It utilizes **Terraform** and the official Okta Provider to automate the deployment of users, security policies, and application integrations in a predictable, version-controlled manner.

## 🏗️ Deployment Methodology

This architecture follows a strict **4-Phase Deployment Strategy** to ensure a secure, zero-friction rollout. The repository structure mirrors these phases to maintain clear separation of duties and simplify security audits.

### Phase 1: The Foundation (Identity Sources)
* **Objective:** Define the "Who."
* **Components:** Core Groups, Group Rules, Custom Profile Attributes, and Directory Integrations.
* **Files:** `identity_sources.tf`

### Phase 2: The Perimeter (Security & Authentication)
* **Objective:** Define the "How."
* **Components:** Network Zones, Authenticators (WebAuthn, Okta Verify), Global Session Policies, and Passwordless routing rules.
* **Files:** `security_perimeter.tf`, `policies_global.tf`

### Phase 3: The Payload (Applications)
* **Objective:** Define the "What."
* **Components:** SAML/OIDC Application definitions, App Sign-On Policies, and Group assignments.
* **Files:** `apps.tf`, `policies_app.tf`

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