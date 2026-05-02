# ADMIN_RUNBOOK: Passwordless Administration & Troubleshooting

**Purpose:** Procedures for administrators managing passwordless authentication. For ops team, support staff, and identity engineers.

---

## 👤 Administrator Roles & Responsibilities

### Account Recovery Admins
- Reset user device bindings (when user loses device)
- Issue recovery codes (one-time use backup codes)
- Assist with account recovery disputes
- Monitor recovery requests in system log

### Device Trust Administrators
- Reset device binding on specific devices
- Override device binding for security incidents
- Audit device enrollment status

### Identity Engineers (Full Admin)
- Deploy passwordless policies (Terraform)
- Configure authenticators and constraints
- Design and test new recovery procedures
- Analyze authentication failure patterns

---

## 🔧 Common Admin Tasks

### Task 1: Reset User Device Binding (Device Lost)

**Scenario:** User lost phone, needs to re-enroll

**Procedure:**

**Step 1: Verify Identity (Out-of-Band)**
```
1. Contact user via phone or in-person
2. Confirm:
   - Last login date/time
   - Device type (iPhone, Android, laptop)
   - Location of last login
3. Ask security question (if configured)
4. Document verification in ticket
```

**Step 2: Reset Device Binding (Admin API)**

Using Okta CLI:
```bash
# Get user ID
okta api /api/v1/users --filter "profile.login eq \"user@example.com\"" | jq '.[] | .id'

# Get user's factors
okta api /api/v1/users/{userId}/factors | jq '.[] | {id, status, factorType}'

# Delete specific factor (device binding)
okta api /api/v1/users/{userId}/factors/{factorId} -m DELETE

# Or reset ALL factors (more aggressive)
okta api /api/v1/users/{userId}/factors -m DELETE
```

Using Terraform (if managing as code):
```hcl
# Reset user via Okta provider
resource "okta_user" "user_reset" {
  first_name = "John"
  last_name  = "Doe"
  login      = "john.doe@example.com"
  email      = "john.doe@example.com"
  
  # This creates new reset link
  password_inline_hook {
    id = okta_inline_hook.password_reset.id
  }
}
```

**Step 3: Generate Recovery Codes (One-Time Use)**

```bash
# Generate new recovery codes for user
okta api /api/v1/users/{userId}/recovery-codes -m POST

# Returns: Array of 10 backup codes (6-8 digit each)
# User can use ONE code to regain access
# Each code: Single-use, time-limited (usually 24 hours)
```

**Step 4: Notify User**
```
Email:
Subject: Account Recovery Complete - Re-enroll Authenticators

Dear User,

Your account recovery has been processed. Please follow these steps
to regain access:

1. Go to https://your-org.okta.com/login
2. Enter your username
3. Click "Use recovery code"
4. Enter: [RECOVERY_CODE_HERE]
5. You'll get temporary access (15 minutes)
6. Go to Settings → Add Authenticator
7. Re-enroll Okta Verify + WebAuthn

If recovery code expires or doesn't work, contact support.

Recovery Window: 24 hours from this email
```

**Timeline:** 24-48 hours (including user re-enrollment)

---

### Task 2: Issue Emergency Recovery Code

**Scenario:** User has legitimate emergency (lost authenticator access, urgent deadline, etc.)

**Procedure:**

**Step 1: Authenticate Requester**
```
1. Verify: User identity (call them, check from known number)
2. Confirm: Reason for emergency (business justification)
3. Log: Ticket with timestamp and justification
4. Approval: Get 2nd admin to approve (security check)
```

**Step 2: Generate Code**
```bash
# Issue recovery code
okta api /api/v1/users/{userId}/recovery-codes -m POST -d '{"count": 1}'

# Returns: Single recovery code (valid 24 hours)
```

**Step 3: Deliver Code**
```
Secure Delivery (pick one):
1. Phone call: Read code over the phone (record call)
2. In-person: Hand-deliver code or QR
3. Encrypted email: Use company encrypted email system
4. Ticket system: Add to admin ticket (if internal user)

NEVER:
- Post in Slack or Teams chat (unencrypted)
- Email in plaintext (interceptable)
- SMS (vulnerable to interception)
```

**Step 4: Verify Usage**
```
After user reports successful login:
1. Check system log: /api/v1/logs?filter=eventType eq "user.authentication.auth_via_recovery_code"
2. Confirm: User ID, timestamp, success status
3. Close ticket
```

**Timeline:** 15-30 minutes (expedited)

---

### Task 3: Troubleshoot Authentication Failure

**Scenario:** User reports "Can't authenticate" or "Device binding error"

**Troubleshooting Flowchart:**

```
User can't authenticate
  ↓
[Check 1] Is user ACTIVE in Okta?
  → If NO: Activate user (contact admin)
  → If YES: Continue
  ↓
[Check 2] Does user have Okta Verify enrolled?
  → If NO: Guide user to re-enroll
  → If YES: Continue
  ↓
[Check 3] Is device bound to user account?
  → If NO: User trying new device (expected)
       Guide: Use recovery code OR recovery email
  → If YES: Continue
  ↓
[Check 4] Is Okta Verify app updated?
  → If NO: User should update app from store
  → If YES: Continue
  ↓
[Check 5] Check system logs for errors
  → If "Device Binding Required": See device binding troubleshooting
  → If "Biometric Failed": See biometric troubleshooting
  → If "Network Error": Check Okta API status
```

**API: Get User Factor Status**

```bash
# List all user's factors
okta api /api/v1/users/{userId}/factors

# Sample response:
# [
#   {
#     "id": "okta_verify_factor_id",
#     "status": "ACTIVE",
#     "factorType": "okta",
#     "provider": {
#       "name": "OKTA",
#       "type": "OKTA"
#     }
#   },
#   {
#     "id": "webauthn_factor_id",
#     "status": "ACTIVE",
#     "factorType": "webauthn",
#     "provider": {
#       "name": "FIDO2/WebAuthn"
#     }
#   }
# ]
```

**Common Errors & Solutions:**

| Error | Cause | Solution |
|-------|-------|----------|
| "Device Binding Required" | Trying to login from new device | User needs to use recovery code or registered device |
| "Biometric Failed" | Biometric scan not recognized | Try again, check phone for dirt on sensor |
| "Okta Verify Not Found" | App not installed or force-closed | Reinstall app, ensure notifications enabled |
| "Invalid Recovery Code" | Code expired or already used | Generate new recovery code |
| "Session Timeout" | Admin sessions expire after 30 min | Re-authenticate |

---

### Task 4: Audit User Factor Enrollment

**Scenario:** Verify users are properly enrolled in passwordless factors

**Procedure:**

```bash
# Get ALL users and their factor status
okta api /api/v1/users \
  --filter 'status eq "ACTIVE"' \
  --limit 200 | jq '.[] | 
    {
      userId: .id,
      login: .profile.login,
      email: .profile.email
    }'

# For each user, get factors
for userId in $(okta api /api/v1/users --filter 'status eq "ACTIVE"' \
  --limit 200 | jq -r '.[] | .id'); do
  echo "User: $userId"
  okta api /api/v1/users/$userId/factors | jq '.[] | {factorType, status}'
done
```

**Expected Output (Good):**
```
User: 00u123abc456
  {
    "factorType": "okta",
    "status": "ACTIVE"
  }
  {
    "factorType": "webauthn",
    "status": "ACTIVE"
  }
```

**Expected Output (Warning):**
```
User: 00u789def012
  {
    "factorType": "okta",
    "status": "ACTIVE"
  }
  # No WebAuthn - only single factor!
```

**Action:** If users missing backup authenticators:
1. Send email reminder to enroll WebAuthn
2. Set enrollment deadline (e.g., 2 weeks)
3. Create policy to require 2nd factor (optional)

---

### Task 5: Monitor Admin Access (High Privilege)

**Scenario:** Audit who accessed admin console and when

**Procedure:**

```bash
# Get admin access logs (past 24 hours)
okta api /api/v1/logs \
  --filter 'eventType eq "user.authentication.auth_success" and target.displayName eq "Okta Admin Console"' \
  --since $(date -u -d '1 day ago' +%Y-%m-%dT%H:%M:%SZ)

# Parse response for audit trail
# Shows:
# - User ID / email
# - Timestamp
# - Device info
# - Location/IP address
# - MFA method used (Okta Verify, WebAuthn, etc.)
```

**Expected Output (Good):**
```
{
  "eventType": "user.authentication.auth_success",
  "published": "2026-05-01T13:00:00.000Z",
  "actor": {
    "id": "00u123abc",
    "displayName": "admin@company.com",
    "type": "User"
  },
  "client": {
    "ipAddress": "203.0.113.42",
    "geographicalContext": {
      "country": "US",
      "state": "CA",
      "city": "San Francisco"
    }
  },
  "authenticationContext": {
    "authenticationProvider": "okta",
    "authenticationStep": 1,
    "issuedAt": "2026-05-01T13:00:00.000Z"
  }
}
```

**Red Flags (Investigate):**
- Admin access from unusual location/IP
- Admin access outside business hours
- Multiple failed attempts before success
- WebAuthn or biometric failures (suggests compromise attempt)

---

## 🆘 Incident Response Procedures

### Incident: Suspected Account Compromise

**Scenario:** Admin account may have been compromised

**Response (Immediate - Next 15 Minutes):**

```bash
# Step 1: Revoke all sessions
okta api /api/v1/users/{userId}/sessions -m DELETE

# Step 2: Reset all factors (forces re-enrollment)
okta api /api/v1/users/{userId}/factors -m DELETE

# Step 3: Generate new recovery codes
okta api /api/v1/users/{userId}/recovery-codes -m POST

# Step 4: Check login history
okta api /api/v1/logs --filter "actor.id eq \"{userId}\"" --limit 50

# Step 5: Check for suspicious API calls
okta api /api/v1/logs --filter "actor.id eq \"{userId}\" AND eventType eq \"app.signon.sign_in_failure\""
```

**Response (Follow-up - Next 24 Hours):**

1. **Change any stored admin passwords** (if they exist)
2. **Check for policy modifications** in Terraform commits
3. **Audit Okta API tokens** (disable if suspicious)
4. **Review recovery codes** issued in past 7 days
5. **Notify security team** and file incident report

**Prevention Going Forward:**

```hcl
# Ensure admin policy has short session timeout
resource "okta_policy_rule_signon" "admin_passwordless_rule" {
  policy_id = okta_policy_signon.admin_passwordless.id
  
  # Short session for admins
  session_lifetime = 30  # 30 minutes instead of 120
  
  # Inactivity timeout
  inactivity_period = "PT15M"  # 15 minutes
}
```

---

### Incident: Okta API Outage

**Scenario:** Okta API is down, users can't authenticate

**Response (Immediate):**

1. **Check Okta Status Page:** https://status.okta.com/
2. **Notify users:** "We're experiencing issues. Trying to resolve ASAP."
3. **Internal communication:** Slack #incident, PagerDuty alert
4. **Contact Okta support:** Premium support phone line

**Workaround (If possible):**

- If local Okta MFA works (device bound), users can still authenticate
- Admin console may be inaccessible (API required)
- Recommend users wait for service restoration

**Timeline:** Usually 15-30 minutes for Okta to resolve

---

### Incident: Email Recovery Not Working

**Scenario:** Recovery email not sending to users

**Checks:**

```bash
# Check if email factor still active
okta api /api/v1/authenticators?filter=key%20eq%20%22okta_email%22 | jq '.[] | .status'

# If INACTIVE: This is expected (email disabled for passwordless)
# Users should use:
# 1. Admin-assisted recovery
# 2. Emergency contact recovery
# 3. Recovery codes (if saved)

# If ACTIVE: Check email routing
# 1. Okta Admin Console → Settings → Email
# 2. Verify: SMTP configured correctly
# 3. Check: Email logs for delivery errors
```

---

## 📊 Monitoring & Health Checks

### Daily Health Check Script

**Location:** `scripts/health-check.sh`

**Run:**
```bash
export OKTA_ORG_NAME="your-org"
export OKTA_API_TOKEN="your-api-token"

bash scripts/health-check.sh --verbose

# Or for monitoring integration
bash scripts/health-check.sh --json | jq '.'
```

**Key Metrics:**

| Metric | Good | Warning | Critical |
|--------|------|---------|----------|
| Okta API Response | <500ms | 500-2000ms | >2000ms or timeout |
| Authenticators Active | All enabled | 1 disabled | Multiple disabled |
| Admin Logins | <5/hour | 5-20/hour | >20/hour (attack?) |
| Recovery Requests | <2/day | 2-10/day | >10/day (high turnover) |
| Failed Auth Rate | <1% | 1-5% | >5% (something wrong) |

### Set Up Monitoring Alerts

**Datadog Integration:**

```python
# Send health check results to Datadog
from datadog_api_client import ApiClient, Configuration

def send_passwordless_metrics():
    # Run health check
    result = subprocess.run(
        ["bash", "scripts/health-check.sh", "--json"],
        capture_output=True, text=True
    )
    
    data = json.loads(result.stdout)
    
    # Send metrics
    api_client = ApiClient(Configuration())
    
    for metric_name, value in [
        ("okta.passwordless.checks.passed", data["passed"]),
        ("okta.passwordless.checks.failed", data["failed"]),
        ("okta.passwordless.checks.warnings", data["warnings"]),
    ]:
        api_client.send_metric(metric_name, value)
```

**Slack Alerts:**

```bash
#!/bin/bash
# Send health check to Slack

HEALTH=$(bash scripts/health-check.sh --json)
FAILED=$(echo $HEALTH | jq '.failed')

if [ "$FAILED" -gt 0 ]; then
  curl -X POST $SLACK_WEBHOOK \
    -H 'Content-type: application/json' \
    -d "{
      \"text\": \"⚠️ Passwordless Auth Health Check Failed\",
      \"attachments\": [
        {
          \"color\": \"danger\",
          \"text\": \"$HEALTH\"
        }
      ]
    }"
fi
```

---

## 🔐 Security Best Practices for Admins

### Admin Account Security

1. **Use strongest authenticators:**
   - Hardware security key (YubiKey) as primary
   - Okta Verify with biometric as backup

2. **Never share admin credentials:**
   - No shared admin accounts
   - Use personal accounts with MFA
   - Rotate passwords monthly (if password exists)

3. **Use separate device for admin access:**
   - Dedicated laptop for admin tasks
   - Don't use personal devices for admin console

4. **Monitor admin activity:**
   - Check logs weekly
   - Set up alerts for unusual access
   - Review failed login attempts

### API Token Security

```bash
# Create API token for automation
okta api /api/v1/api-tokens

# Security best practices:
# 1. Limit scope to minimal required permissions
# 2. Use different tokens for different systems
# 3. Rotate tokens every 90 days
# 4. Store in secure secret manager (AWS Secrets Manager, etc.)
# 5. Never commit tokens to Git

# Check for old/unused tokens
okta api /api/v1/api-tokens | jq '.[] | {name, created, lastUsed}'
```

### Terraform Apply Safety

Before running `terraform apply`:

```bash
# 1. Review plan
terraform plan -out=tfplan

# 2. Show only changes
terraform show tfplan | grep -E "^\s+[~-]"

# 3. Backup current state
cp terraform.tfstate terraform.tfstate.backup.$(date +%s)

# 4. Dry-run in test environment first
terraform apply tfplan -var-file=test.tfvars -auto-approve

# 5. Wait 24 hours for validation
# ... monitor logs, test user workflows ...

# 6. THEN apply to production
terraform apply tfplan -auto-approve
```

---

## 📞 Escalation Procedures

### Level 1: Support Team (This Guide)
- Password reset / device binding
- Recovery codes
- Basic troubleshooting

**Escalate to Level 2 if:**
- Multiple users affected
- System-wide authentication failures
- API errors / Okta service issues

### Level 2: Identity Engineering
- Policy modifications
- Authenticator configuration
- Complex recovery scenarios

**Escalate to Level 3 if:**
- Terraform state corruption
- Okta organization misconfiguration
- Security incidents

### Level 3: Okta Premium Support
- Okta API bugs
- Infrastructure issues
- Custom feature requests

**Contact:** Okta Support Portal or premium support phone line

---

## 📚 Reference

### Okta API Documentation
- User Management: https://developer.okta.com/docs/api/openapi/okta-management/management/tag/users/
- Factors: https://developer.okta.com/docs/api/openapi/okta-management/management/tag/user-factors/
- Recovery Codes: https://developer.okta.com/docs/api/openapi/okta-management/management/tag/recovery-codes/
- Logs: https://developer.okta.com/docs/api/openapi/okta-management/management/tag/system-logs/

### Internal Resources
- `ARCHITECTURE.md` - Technical deep-dive
- `PASSWORDLESS_GUIDE.md` - User guide
- `recovery-config.tf` - Recovery configuration code
- `scripts/health-check.sh` - Monitoring script

---

**Last Updated:** 2026-05-01
**Version:** 1.0 (Passwordless Phase 5 Complete)

**Document Owner:** Identity Engineering Team
**Review Cycle:** Quarterly
**Next Review:** 2026-08-01
