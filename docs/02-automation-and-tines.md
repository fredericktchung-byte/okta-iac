# SOAR Pipeline: Contractor ID Generation

## The Duplicate Vulnerability
Okta's native matching rules struggle with duplicate manual entries from HR or external admins. We utilize Tines as an intercepting SOAR pipeline to evaluate net-new contractors before they pollute the directory.

## Trigger Mechanism
* **Source:** Salesforce Record-Triggered Flow (`User` object).
* **Entry Condition:** `User_Type__c` Equals `Contractor`.
* **Delivery:** Salesforce HTTP Callout utilizing a Named Credential (`Tines_API_Base`).
* **Security:** The Tines Webhook secret is truncated from the URL and passed securely inside an encrypted TLS header (`Authorization: Bearer <secret>`).

## Future Enhancements / Technical Debt
* **Personal Email Mapping:** Currently, the Salesforce `User` object lacks a custom `Personal_Email__c` field. Tines relies on the standard email field for duplicate checking. 
* **Recommendation:** Create a custom Personal Email field in Salesforce, map it to Okta's secondary email attribute, and update the Tines composite key search to include it for higher-fidelity duplicate detection.