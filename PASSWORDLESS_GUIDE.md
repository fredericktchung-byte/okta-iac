# PASSWORDLESS_GUIDE: User Enrollment & Authentication

**Purpose:** This guide explains how to use passwordless authentication in this Okta environment. For end users and team members.

---

## 🎯 What is Passwordless Authentication?

**Instead of:**
```
1. Type username
2. Type password
3. Enter authentication code from app
4. Click approve
```

**You do:**
```
1. Type username
2. Approve push notification (or use security key)
3. ✓ Logged in
```

**Security benefit:** No passwords = no password compromises, phishing attacks, credential stuffing.

---

## 📱 Getting Started (First Time Setup)

### Step 1: Enroll Okta Verify (Push Notifications)

**What you need:** iPhone or Android phone with Okta Verify app

#### On Desktop:
1. Go to Okta login: `https://your-org.okta.com`
2. Enter username and password (last time you'll type this)
3. You'll see: "Set up your security authenticator"
4. Click "Set Up" → Select "Okta Verify"
5. Follow the QR code scan instructions

#### On Mobile (Okta Verify App):
1. Open Okta Verify app
2. Tap "+" (Add Account)
3. Select "Organization" or "Okta Account"
4. Scan QR code from desktop
5. Choose: "Verify with biometric or PIN"
6. Set up your fingerprint or Face ID
7. Confirm setup complete

**Result:** 
- ✅ Push notifications enabled
- ✅ You can now approve sign-ins from your phone
- ✅ Device binding activated (authentication tied to this device)

---

### Step 2: Enroll WebAuthn/FIDO2 (Optional but Recommended)

**What you need:** One of:
- Hardware security key (YubiKey 5, Google Titan, etc.)
- Built-in platform authenticator (Windows Hello, Face ID, Touch ID)

#### Option A: Built-In Biometric (Easiest)

1. Go to Okta Admin Console → Settings → Account
2. Click "Add Authenticator" → Select "Security Key or Biometric"
3. Choose: "Platform Authenticator" (Windows Hello, Face ID, etc.)
4. Verify with your biometric (face, fingerprint, or PIN)
5. ✅ Complete!

**Result:**
- ✅ Can authenticate using Windows Hello / Face ID / Touch ID
- ✅ No hardware key needed
- ✅ Works on any device with biometric hardware

#### Option B: Hardware Security Key (Most Secure)

1. Plug in your security key (YubiKey, Titan, etc.)
2. Go to Okta Admin Console → Settings → Account
3. Click "Add Authenticator" → Select "Security Key or Biometric"
4. Choose: "Security Key"
5. Follow USB/NFC prompts
6. ✅ Complete!

**Result:**
- ✅ Can authenticate with security key
- ✅ Hardware-backed cryptography (extremely secure)
- ✅ Can use same key on multiple devices

---

## 🔐 Logging In (Daily Use)

### Scenario 1: Using Okta Verify Push

```
1. Go to Okta login: https://your-org.okta.com
2. Enter username → Next
3. Enter password → Wait (this is unusual, but it still works during transition)
4. Look at your phone 📱
5. Okta Verify app shows: "Sign in to Okta?"
6. Tap "Approve" or use fingerprint
7. ✅ Logged in!
```

**Time:** ~5 seconds (faster than typing password + OTP code)

### Scenario 2: Using Security Key / Biometric

```
1. Go to Okta login: https://your-org.okta.com
2. Enter username → Next
3. Click "Use security key or biometric"
4. Choose your authenticator (Touch ID, Windows Hello, Security Key, etc.)
5. Complete biometric verification (face, fingerprint) or insert key
6. ✅ Logged in!
```

**Time:** ~3 seconds (fastest option, no phone needed)

### Scenario 3: Using Recovery Code (Device Lost)

```
1. Go to Okta login
2. Enter username → Next
3. Click "Can't access your authenticator?"
4. Enter recovery code (from codes saved at enrollment)
5. ✅ Temporary access granted
6. Go to Settings → Update authenticators
7. Set up new device with Okta Verify
```

**Time:** Varies (see recovery section below)

---

## 🆘 Help & Troubleshooting

### "I'm getting 'Device Binding Required' error"

**Cause:** This device hasn't been bound to your account yet.

**Solution:**
1. Use different device (one you enrolled Okta Verify on)
2. Approve push notification or use security key
3. ✅ Login successful

**Why?** Security feature: Can't authenticate from random devices (protects against stolen credentials).

---

### "Okta Verify isn't showing a push notification"

**Causes & Fixes:**

1. **Phone not connected to internet**
   - ✓ Check WiFi or cellular connection
   - ✓ Try approving from app manually (open Okta Verify → See pending requests)

2. **Okta Verify app crashed**
   - ✓ Force close app and reopen
   - ✓ Check app store for updates
   - ✓ Reinstall if persistent

3. **Notification blocked by phone OS**
   - iPhone: Settings → Okta Verify → Notifications → Allow
   - Android: Settings → Apps → Okta Verify → Permissions → Notifications → Allow

4. **Last resort: Use backup authenticator**
   - If you enrolled WebAuthn/FIDO2, use that instead
   - Contact support if both methods fail

---

### "I lost my phone / device broke"

**Recovery Flow (Admin-Assisted):**

1. **Don't panic.** There's a recovery process.

2. **Contact your Okta administrator:**
   - Email: [admin email]
   - Message: "Lost device, need account recovery"

3. **Admin will verify your identity:**
   - Name, email, last few Okta login dates
   - Security question (if configured)
   - Out-of-band verification (phone call, etc.)

4. **Admin resets your device binding:**
   - Clears all enrollments
   - You get temporary access

5. **You re-enroll on new device:**
   - Set up Okta Verify again
   - Set up security key/biometric
   - ✅ Full access restored

**Timeline:** Usually 24-48 hours during business hours

**To speed this up:**
- Save your recovery codes in a password manager
- Have a trusted contact on file (emergency recovery)

---

### "I saved recovery codes - how do I use them?"

**When You Have Recovery Codes:**

```
1. Go to Okta login
2. Enter username → Next
3. Click "Can't access your authenticator?"
4. Select "Use recovery code"
5. Enter one of your recovery codes
6. ✅ Temporary session (15 minutes)
7. Go to Settings → Add new authenticator
8. Set up on replacement device
9. ✅ Full access restored
```

**Recovery Codes:**
- Given to you at enrollment time
- Single-use only (each code works once)
- Time-limited (usually 24 hours)
- Save them in password manager or secure location

**To view your codes anytime:**
1. Okta Admin Console → Security → Account
2. Click "Show Recovery Codes"
3. Take a screenshot or download PDF
4. Store securely

---

### "What if I have accessibility needs?"

**For Users with Mobility Limitations:**

- Okta Verify: Supports voice assistance
- Windows Hello: Works with eye-gaze controls
- Touch ID / Face ID: Available for Mac/iPhone
- PIN: Can use 4-digit PIN instead of biometric
- Contact support for accommodations

**For Blind / Low Vision Users:**

- Screen readers: Okta login supports NVDA, JAWS
- High contrast: Available in Okta settings
- Recovery codes: Can be shared with accessibility assistant

---

## 📚 Advanced Topics

### Understanding Device Binding

**What is Device Binding?**

Your authentication is tied to the specific device you enrolled on. This means:

✅ **Secure:**
- Stolen password = useless (attacker can't authenticate from different device)
- Attacker needs BOTH password AND your device

❌ **Inconvenience:**
- Can't login from brand new laptop (no account access from new devices)
- Must use enrolled device or do recovery process

**How to Enroll on Additional Devices:**

1. Get temporary access on device you enrolled on
2. Go to Okta Admin Console → Security → Account
3. Click "Add Authenticator"
4. Enroll Okta Verify on new device
5. Set up biometric on new device
6. ✅ New device now bound to your account

---

### Channel Binding (Phishing Protection)

**What is Channel Binding?**

Extra security during risky logins (unusual location, device, etc.):

```
1. You click login
2. Okta detects: "This login looks unusual"
3. Okta Verify shows: "Enter number: 123456"
4. Your screen shows: "Confirm: 123456"
5. You verify numbers match
6. ✅ Proves you're really approving this login (not attacker)
```

**Why?** If attacker intercepts login:
- They see different number on their screen
- You see different number on your screen
- You don't approve (because numbers don't match)
- Attack fails

---

### Session Management

**Session Length by User Type:**

| User Type | Session Timeout | Inactivity Timeout |
|-----------|-----------------|-------------------|
| Regular User | 120 minutes | 12 hours |
| Admin | 30 minutes | 15 minutes |
| Support Team | 60 minutes | 6 hours |

**What this means:**
- Regular user: After 120 min, must re-authenticate (even if using computer)
- Admin: After 30 min, must re-authenticate (stricter for high-privilege)
- 15 min inactivity: If you walk away from desk, need to re-auth

**To see your current session:**
- Okta Admin Console → Settings → Sessions
- Shows: Login time, device info, location

---

## 🎓 Key Concepts (For Technical Users)

### FIDO2 / WebAuthn

- **Standards-based** passwordless authentication
- **No shared secrets** (your private key never leaves device)
- **Phishing-resistant** (cryptographically bound to domain)
- **Cross-platform** (works on Windows, Mac, iOS, Android)

**How it works:**
```
1. Okta sends challenge (random string)
2. Your security key signs the challenge with private key
3. Okta verifies signature with your public key
4. ✅ Authentication proven
```

**Why secure?**
- Attacker can't intercept (private key never transmitted)
- Works even with phishing (signature is domain-specific)
- Can't be replayed (challenge is random each time)

---

### Possession vs. Verification

**Possession** = "What you have" (device, security key)
- Example: Okta Verify on your phone
- Protection: Attacker needs your physical device

**Verification** = "Who you are" (biometric, PIN)
- Examples: Fingerprint, Face ID, PIN
- Protection: Attacker needs to be you (or your biometric)

**Together:** Possession + Verification = Strong authentication
- Attacker needs: Device AND biometric
- Much harder to compromise than password alone

---

## 📞 Support & Resources

**Problem?** Check here:

| Issue | Resource |
|-------|----------|
| Can't login | This guide (Troubleshooting section) |
| Forgot recovery codes | Contact admin support |
| Lost device | Contact admin support (24-48 hour recovery) |
| Accessibility needs | Contact admin support + accessibility team |
| General questions | See ARCHITECTURE.md (technical deep-dive) |

**Contact:**
- Support Email: [support@yourorg.okta.com]
- Support Slack: #okta-support
- Admin Console: Help → Contact Support

---

## ✅ Checklist: You're Set Up Properly

- [ ] Okta Verify installed and working (push notifications receiving)
- [ ] At least one backup authenticator enrolled (security key OR biometric)
- [ ] Recovery codes saved in password manager
- [ ] Emergency contact configured (trusted colleague or family)
- [ ] Successfully logged in passwordless (no password typed)
- [ ] Tested recovery process (in test environment)

---

## 🔗 Related Resources

- **ARCHITECTURE.md:** Technical deep-dive into passwordless implementation
- **ADMIN_RUNBOOK.md:** For administrators and support team
- **README.md:** Project overview
- **FIDO2 Alliance:** https://fidoalliance.org/ (standards documentation)

---

**Last Updated:** 2026-05-01
**Version:** 1.0 (Passwordless Phase 5 Complete)
