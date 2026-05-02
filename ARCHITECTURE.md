# ARCHITECTURE: Okta Passwordless Authentication Implementation

**Purpose:** This document explains the passwordless authentication architecture deployed in this repository and what it demonstrates for a security-focused portfolio.

---

## 🎯 What This Demonstrates

### For Recruiters/Viewers:
- ✅ **Modern Authentication Standards** - FIDO2/WebAuthn instead of password-based MFA
- ✅ **Zero-Trust Security Principles** - Device binding, mandatory biometric verification, phishing-resistant authentication
- ✅ **Enterprise Architecture** - Disaster recovery, rollback automation, compliance-first design
- ✅ **Infrastructure as Code Maturity** - Version-controlled, tested, policy-driven identity management
- ✅ **Operational Excellence** - Health checks, monitoring, incident response procedures
- ✅ **Security Decision-Making** - Why certain constraints are chosen, trade-offs between UX and security

---

## 🏗️ Architecture Overview

### Authentication Factors Deployed

#### 1. **Okta Verify (FastPass) - Passwordless Push Notifications**

```
User Login → Okta Verify App → Push Notification → User Approval → Session Granted
```

**Key Features:**
- **Device Binding (REQUIRED)**: Authentication tied to specific device (cryptographic binding)
  - Prevents: Token theft on other devices, shared device attacks
  - UX: User must use enrolled device; can't use borrowed phone
  
- **User Verification (REQUIRED)**: Biometric or PIN verification
  - Prevents: Attackers with stolen device can't authenticate
  - Uses: Fingerprint, Face ID, Windows Hello, PIN (fallback)
  
- **Channel Binding (HIGH_RISK)**: Phishing-resistant challenge
  - Prevents: Man-in-the-middle phishing attacks
  - How: User sees 6-digit challenge on login screen, must match app notification

**Configuration in Repo:**
- File: `authenticators.tf` (lines 35-74)
- Settings: FastPass enabled, device binding REQUIRED, biometric REQUIRED

---

#### 2. **WebAuthn (FIDO2) - Standards-Based Hardware & Platform Authenticators**

```
User Enrolls Hardware Key (YubiKey, etc.) → Signs Challenge with Private Key → Session Granted
```

**Key Features:**
- **Platform Authenticators (ENABLED)**:
  - Windows Hello (fingerprint, face, PIN)
  - macOS Touch ID / Face ID
  - Android Face Unlock / Fingerprint
  - Best UX: Built-in device authenticators

- **Resident Keys (PREFERRED)**:
  - Backup recovery codes if device lost
  - User can self-recover without admin intervention

- **User Verification (REQUIRED)**:
  - Biometric or PIN needed; no passwordless without verification

**Configuration in Repo:**
- File: `authenticators.tf` (lines 76-104)
- Standards: FIDO2/WebAuthn compliant, cross-browser compatible

---

### Policy & Constraint Architecture

#### Sign-On Policies (Implemented)

1. **Default Passwordless Policy** (`policies.tf`)
   - Applied to: Everyone group
   - Factors: Okta Verify OR WebAuthn (user choice)
   - Session: 120 minutes
   - MFA Prompt: Always

2. **Admin Console Policy** (`policies_admin.tf`)
   - Applied to: Admin group
   - Factors: Okta Verify with mandatory biometric (no PIN fallback)
   - Device Binding: REQUIRED (prevents admin from borrowed device)
   - Session: 30 minutes (short for high-privilege access)
   - Inactivity: 15 minutes re-auth trigger

3. **Recovery Policy** (`recovery-config.tf`)
   - For: Account recovery without password
   - Methods: Admin-assisted, emergency contact approval

#### Constraint Structure (Critical Security Layer)

**What Constraints Do:**
Constraints define *how* authentication must occur. They're stricter than policies.

```json
OLD ARCHITECTURE (Password-Based):
{
  "knowledge": {
    "types": ["password"],
    "required": true
  }
}
Risk: Password compromise = account compromise (single knowledge factor)

NEW ARCHITECTURE (Passwordless):
{
  "possession": {
    "required": true,
    "deviceBound": "REQUIRED"
  },
  "verification": {
    "required": "REQUIRED",
    "methods": ["BIOMETRICS", "PIN"]
  }
}
Benefit: Requires TWO factors (device binding + biometric/PIN) = zero-trust
```

**Files with Constraints:**
- `policies_global.tf`: Default and high-assurance rules (lines 62-140)
- `policies_admin.tf`: Admin-specific constraints (lines 44-164)

---

## 🔐 Zero-Trust Principles Implemented

| Principle | Implementation | Security Benefit |
|-----------|----------------|------------------|
| **Never Trust, Always Verify** | Device binding REQUIRED + biometric REQUIRED | Can't authenticate without both device AND user verification |
| **Assume Breach** | No password fallback possible | Even if password DB compromised, zero impact (no passwords exist) |
| **Verify Explicitly** | Channel binding on high-risk | Prevents phishing attacks where attacker intercepts login |
| **Use Least Privilege** | Admin policies stricter than user policies | Admin compromise has limited blast radius |
| **Encrypt Everything** | WebAuthn uses cryptographic key exchange | No shared secrets = no interception vectors |
| **Secure by Default** | Recovery requires admin approval | Prevents unauthorized account takeover during recovery |

---

## 📊 Comparison: Password-Based vs. Passwordless

| Dimension | Traditional MFA | Passwordless (This Implementation) |
|-----------|-----------------|-----------------------------------|
| **Attack Vectors** | Password compromise, phishing, credential stuffing | None (no passwords, device-bound) |
| **User Experience** | Type password → App 2FA prompt | Approve push OR use biometric |
| **Recovery** | Forgot password email → reset flow | Admin-assisted or emergency contact |
| **High-Risk Scenarios** | Can't detect borrowed device | Device binding enforces known device only |
| **Admin Access** | Password + optional MFA | Mandatory biometric + device binding + short session |
| **Compliance** | Moderate (password policy checks) | Strong (FIDO2 certified, phishing-resistant) |

---

## 🚀 Deployment Architecture

### Phased Rollout Strategy (In Repo)

See `.github/workflows/deploy-passwordless.yml`:

```
Stage 1: Pre-Flight Validation
↓
Stage 2: Staging Environment
↓
Stage 3: Canary Deployment (10% of users)
↓
Stage 4: Progressive Rollout (25% → 50% → 75% → 100%)
↓
Stage 5: Hardening & Monitoring
```

**Why Phased?**
- Catch issues early with small user population
- Allows user feedback loop
- Can rollback quickly if problems detected
- Demonstrates enterprise deployment maturity

### Rollback Automation (In Repo)

See `.github/workflows/rollback-passwordless.yml`:

- **RTO (Recovery Time Objective):** 10-15 minutes
- **RPO (Recovery Point Objective):** Real-time (backup before every apply)
- **Trigger:** Manual approval (Safety first)
- **Process:** Restore Terraform state → Re-apply → Verify health checks

This demonstrates:
- Production-grade CI/CD discipline
- Disaster recovery thinking
- Testing before going live

---

## 🔄 Recovery Architecture (Critical for Passwordless Success)

### Problem: What happens when user loses device?

**Traditional:** "Forgot password" email → easy account takeover
**Passwordless:** Must have secure recovery mechanism

### Solution Implemented (3 Paths)

#### Path 1: Admin-Assisted Recovery (Primary)
```
User loses device
↓
Contact support / admin
↓
Admin verifies identity (out-of-band)
↓
Admin resets user's device binding (API call)
↓
User re-enrolls Okta Verify + WebAuthn on new device
↓
User regains access
```

**Security:** Requires human verification (can't be automated)
**UX:** Requires support team, 24-48 hour turnaround

#### Path 2: Emergency Contact Recovery
```
User designates trusted contact (spouse, colleague, etc.)
↓
User can't authenticate
↓
User contacts emergency contact
↓
Emergency contact approves recovery (via email/link)
↓
User regains limited access to reset authenticators
```

**Security:** Requires contact approval + user identity verification
**UX:** Self-service but requires trusted third party

#### Path 3: Self-Service with Recovery Codes (Optional)
```
User receives 10 recovery codes at enrollment
↓
User saves codes in secure location (password manager, etc.)
↓
If device lost, user can use recovery code at login
↓
Temporary session allows re-enrollment
```

**Security:** Codes are single-use, time-limited
**UX:** Fastest recovery if user saved codes

**Implementation in Repo:** `recovery-config.tf` (lines 1-250)

---

## 🛡️ Admin Access Security (Highest Priority)

### Why Admin Access Gets Special Treatment

Admin access = highest risk (can modify policies, users, org settings)

### Enhanced Admin Policy Architecture

**File:** `policies_admin.tf`

```
Admin Login Attempt
↓
Verify: Admin group membership
↓
Require: Device binding (can't use shared device)
↓
Require: Biometric verification (PIN not allowed)
↓
Session: 30 minutes (vs. 120 for users)
↓
Inactivity: Auto re-auth after 15 minutes
↓
Logging: All admin actions in system log
```

**What This Proves:**
- Admin access = higher assurance than user access
- Prevents: Shared device compromise (device binding)
- Prevents: Biometric bypass (no PIN fallback)
- Prevents: Long-lived admin sessions (short lifetime)

---

## 📈 Health Check & Monitoring

**File:** `scripts/health-check.sh` (321 lines)

### What Gets Monitored

```bash
✓ Okta API connectivity
✓ Passwordless authenticators active (Okta Verify, WebAuthn)
✓ Legacy factors inactive (Password, Email)
✓ Policies deployed correctly
✓ Recovery groups populated
✓ User enrollment status
✓ Compliance with passwordless standards
```

### Integration Points

- **CI/CD Pipeline:** `terraform-validate.yml` runs health checks
- **Monitoring Systems:** JSON output for Datadog, CloudWatch, etc.
- **On-Call Dashboards:** Real-time passwordless health status
- **Incident Response:** Quick diagnosis of authentication issues

---

## 🎯 What A Recruiter Should Understand

### "Why should I care about passwordless authentication?"

**Business Impact:**
- Passwords are #1 cause of breaches (60% of attacks start with password compromise)
- FIDO2 completely eliminates password attacks
- User experience BETTER (biometric faster than typing password)
- Compliance easier (FIDO2 = strong authentication requirement)

### "How does this show technical depth?"

**This Implementation Proves:**
1. **Security Fundamentals** - Understands zero-trust, device binding, phishing resistance
2. **Enterprise Architecture** - Phased rollout, disaster recovery, monitoring
3. **Identity & Access** - Modern authentication standards, policy design
4. **Infrastructure as Code** - Terraform best practices, version control discipline
5. **Operational Excellence** - Health checks, incident response, runbooks
6. **Decision-Making** - Explains *why* constraints chosen, not just *what* is deployed

### "What would I do in your organization?"

**This candidate can:**
- ✅ Design secure authentication systems (not just implement)
- ✅ Think about operational risk (rollback automation, recovery procedures)
- ✅ Balance security and UX (mandatory biometric vs. PIN fallback)
- ✅ Work with compliance teams (FIDO2 certified, audit trails)
- ✅ Own end-to-end features (policy design → implementation → monitoring)

---

## 📚 Key Files to Understand the Architecture

| File | Purpose | Key Insight |
|------|---------|------------|
| `authenticators.tf` | Okta Verify + WebAuthn config | Device binding REQUIRED, biometric REQUIRED |
| `policies.tf` | Primary passwordless policy | Applied to everyone |
| `policies_admin.tf` | Admin-specific policies | Stricter constraints for high-privilege access |
| `policies_global.tf` | Policy rules with constraints | Shows possession + verification replacing password knowledge |
| `recovery-config.tf` | Recovery flows | Admin-assisted, emergency contact, backup codes |
| `scripts/health-check.sh` | Monitoring script | Validates passwordless infrastructure health |
| `.github/workflows/deploy-passwordless.yml` | Phased deployment | Canary rollout with approval gates |
| `.github/workflows/rollback-passwordless.yml` | Emergency rollback | One-click recovery (RTO: 10-15 min) |

---

## 🔗 Related Reading

- **FIDO2 Alliance:** https://fidoalliance.org/
- **NIST Guidelines:** https://pages.nist.gov/800-63-3/sp800-63b.html
- **Okta Verify Best Practices:** https://developer.okta.com/docs/guides/okta-verify-overview/
- **WebAuthn Standard:** https://webauthn.io/

---

## Questions for Recruiters

**Q: "Isn't passwordless complicated to implement?"**
A: Yes, but the payoff is huge. This repo shows it's possible with modern tools (Terraform, Okta platform) and proper planning (phased rollout, recovery procedures).

**Q: "What if users forget their recovery codes?"**
A: Admin-assisted recovery is the fallback. It's slower but secure (requires manual verification). This is better than password reset (which can be abused).

**Q: "Why both Okta Verify AND WebAuthn?"**
A: Defense in depth. If Okta Verify has an issue, users can still use WebAuthn/FIDO2. Gives users choice (push notifications vs. hardware keys).

**Q: "How does this compare to enterprise systems like Okta/Azure?"**
A: This is using Okta's production API + best practices. Not simplified demo - real enterprise architecture. Candidates working here understand production identity systems.

---

## Version History

- **2026-05-01:** Initial passwordless architecture (Phase 5 complete)
  - Password authenticator: INACTIVE
  - Email authenticator: INACTIVE
  - All users: Passwordless (FastPass, FIDO2)
  - Admins: Enhanced assurance (biometric REQUIRED, device binding REQUIRED)

---

**For questions, see:**
- `PASSWORDLESS_GUIDE.md` - User enrollment walkthrough
- `ADMIN_RUNBOOK.md` - Admin procedures and troubleshooting
- `README.md` - Project overview
