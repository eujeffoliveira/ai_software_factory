# Bad Example — Privacy Assessment

> This is an example of a POOR-QUALITY privacy assessment. Notice: no data classification, assumed compliance, no specific evidence, no legal basis documented, no deletion check. Do NOT produce assessments like this.

---

# Privacy Assessment

## Feature: User Profile Update
## Assessment Date: 2026-05-17
## Overall Privacy Status: COMPLIANT

---

## Privacy Review

The feature collects basic user profile information like name and email. This is standard for any web application.

The team has confirmed that they follow LGPD/GDPR requirements as a general practice.

User data is stored in the database and can be deleted if needed.

**Conclusion:** The feature is privacy-compliant.

---

> ## WHY THIS IS WRONG — ANNOTATED PROBLEMS

> **Problem 1: No data classification performed.**
> Before any privacy assessment, every data entity must be classified (PUBLIC/INTERNAL/CONFIDENTIAL/RESTRICTED). "Basic user profile information" is not a classification. `User.displayName` and `User.email` are CONFIDENTIAL — they are directly identifying PII under LGPD Art. 5(I) and GDPR Art. 4(1). The assessment cannot proceed without classification.

> **Problem 2: "The team has confirmed that they follow LGPD/GDPR" is not evidence.**
> Legal basis for PII processing must be documented for each specific processing activity. What is the legal basis for storing `displayName`? Is it contract, consent, or legitimate interest? Where is this documented? The assessment must cite a specific document (PRD section, privacy notice, terms of service) and the specific legal basis type.

> **Problem 3: "User data can be deleted if needed" is not a deletion assessment.**
> A proper deletion assessment verifies: Is CASCADE DELETE configured in the Prisma schema? Can the organization comply with a Right to Erasure request within the legally required timeframe? What happens to audit_log entries when a user is deleted? None of this is addressed.

> **Problem 4: No audit_log review.**
> The assessment does not check whether `audit_log` entries contain PII. In many implementations, developers accidentally log raw user input or PII values in the `metadata` field. This is a HIGH finding (DR005) that would result in `BLOCKED_PRIVACY_VIOLATION`. The assessment completely omits this check.

> **Problem 5: No consent assessment.**
> If notificationPreferences are collected (as in this feature), explicit consent is required. Has a consent mechanism been implemented? Is consent stored and withdrawable? Not mentioned.

> **Problem 6: No third-party data sharing assessment.**
> User data flows to Supabase (database) and Vercel (hosting) at minimum. Are DPAs in place with these providers? Not checked. This is a mandatory step for LGPD/GDPR compliance.

> **Problem 7: COMPLIANT issued without evidence.**
> A compliance determination without evidence is an assertion, not an assessment. Every COMPLIANT result must be supported by: data classification table, legal basis documentation reference, code-level consent check, Prisma schema verification for deletion, DPA verification, and logging privacy audit.

> **Correct outcome:** This privacy assessment is invalid. `privacy-review-skill` must be re-run with the proper checklist. The feature may actually be compliant, but compliance must be demonstrated with evidence — not stated as a general claim.
