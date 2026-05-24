# Identity Lifecycle Architecture

## The Decoupled Provisioning Model
To prevent infinite sync loops and SAML certificate collisions, our Salesforce Okta integration uses a **Headless Provisioning** architecture. 

We do not use a single Okta application. Instead, we utilize three distinct Okta app instances pointing to the same Salesforce org:
1. **Salesforce (SSO Only):** The primary, user-facing application. API provisioning is completely disabled. This guarantees a single SAML x.509 certificate and Identity Provider Issuer URL, preventing duplicate login buttons on the SP-initiated login page.
2. **Salesforce (Inbound Contractors):** Headless app (hidden from users). Mastered by Salesforce. Pulls newly created contractors into Okta. 
3. **Salesforce (Outbound W2):** Headless app (hidden from users). Mastered by Okta/HR. Pushes internal employee updates (Title, Department) down to Salesforce.

## The Immutable Anchor (SSO)
Email addresses are highly mutable (name changes, domain migrations). To ensure SSO never breaks, the SAML assertion relies on a natively generated, globally unique immutable ID. 
* **Attribute:** `user.salesforceId`
* **Flow:** Salesforce generates the ID upon creation -> Okta imports and stores it via the Inbound API -> Okta passes it back during SSO via SAML.