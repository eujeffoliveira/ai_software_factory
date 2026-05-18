# Privacy Assessment

## Feature: [Feature Name]
## Assessment Date: [YYYY-MM-DD]
## Produced by: Agente07_DevSecOps v1.0.0
## Overall Privacy Status: [COMPLIANT | NON_COMPLIANT | PENDING_HUMAN | NOT_APPLICABLE]

---

## Data Classification Summary

**Highest Classification Tier:** [PUBLIC / INTERNAL / CONFIDENTIAL / RESTRICTED]

| Entity | Type | Classification | PII Fields | Regulatory Obligations |
|--------|------|---------------|-----------|----------------------|
| [User.email] | FIELD | CONFIDENTIAL | email | LGPD Art. 5; GDPR Art. 4 |
| [User.name] | FIELD | CONFIDENTIAL | name | LGPD Art. 5; GDPR Art. 4 |
| [Task.title] | FIELD | INTERNAL | none | None |
| [Add entities] | [TABLE/FIELD/API_RESPONSE] | [tier] | [fields] | [obligations] |

---

## Legal Basis for Data Processing

> **Requirement:** Every CONFIDENTIAL or RESTRICTED data processing activity must have a documented legal basis under LGPD / GDPR.

| Data Category | Processing Activity | Legal Basis | Documented In | Status |
|--------------|---------------------|------------|--------------|--------|
| [User email] | [Account management, login] | CONTRACT (service agreement) | [PRD section / Terms of Service] | ✅ PASS |
| [User profile data] | [Profile display, personalization] | CONSENT (onboarding flow) | [PRD section] | ✅ PASS |
| [Add rows] | [Processing activity] | [BASIS] | [Where documented] | [PASS/FAIL] |

**If no documented legal basis found:** ❌ FAIL → BLOCKED_PRIVACY_VIOLATION

---

## Data Minimization Assessment

> **Requirement:** Only data that is necessary for the stated purpose should be collected and stored.

**Fields collected by this feature:**
| Field | Purpose | Necessary? | Verdict |
|-------|---------|-----------|---------|
| [field name] | [purpose] | YES / NO | ✅ Necessary / ❌ Unnecessary |

**Unnecessary fields identified:** [List or "None"]

**Status:** ✅ PASS / ❌ FAIL

---

## Consent Assessment

> **Requirement:** Explicit consent must be obtained before collecting CONFIDENTIAL data, unless another legal basis applies.

- **Consent required:** YES / NO
- **Consent mechanism:** [e.g., "Onboarding consent form, recorded in UserConsent table"]
- **Consent stored:** YES / NO
- **Consent withdrawal supported:** YES / NO (right to withdraw consent must be provided)

**Status:** ✅ PASS / ❌ FAIL / N/A

---

## Data Deletion (Right to Erasure) Assessment

> **Requirement:** Users must be able to request deletion of their personal data (LGPD Art. 18; GDPR Art. 17).

- **Deletion required:** YES / NO
- **Deletion mechanism:** [e.g., "CASCADE DELETE on User record removes all associated records"]
- **Prisma cascade configured:** YES / NO
- **Soft delete or hard delete:** [HARD DELETE for PII / SOFT DELETE with anonymization]
- **Anonymization on deletion:** YES / NO (acceptable alternative to hard delete)

**Prisma schema cascade check:**
```prisma
// Expected pattern for user-owned data:
model Task {
  userId String
  user   User   @relation(fields: [userId], references: [id], onDelete: Cascade)
}
```

**Status:** ✅ PASS / ❌ FAIL / N/A

---

## Third-Party Data Sharing Assessment

> **Requirement:** If user data is shared with third parties, a Data Processing Agreement (DPA) must be in place.

- **Third-party sharing:** YES / NO
- **Third parties involved:**

| Third Party | Data Shared | DPA in Place | DPA Reference |
|------------|------------|-------------|--------------|
| [e.g., SendGrid] | [email address for transactional emails] | YES / NO | [Contract reference] |
| [e.g., Supabase] | [all user data — database provider] | YES / NO | [DPA URL] |

**Status:** ✅ PASS / ❌ FAIL / N/A

---

## Logging Privacy Assessment

> **Requirement:** `audit_log` and `sync_log` must not contain raw PII.

| Log Type | Call Site | Checked Fields | PII Found | Status |
|----------|-----------|---------------|-----------|--------|
| audit_log | [file:line] | actorId, actorEmail, action, entityType, entityId, metadata | YES / NO | ✅ / ❌ |
| sync_log | [file:line] | action, status, count, error | YES / NO | ✅ / ❌ |

**Specific PII in logs:** [List any PII found, or "None"]

**Status:** ✅ PASS / ❌ FAIL

---

## Privacy Findings

| ID | Severity | Description | Remediation |
|----|---------|-------------|-------------|
| SEC-NNN | [CRITICAL/HIGH/MEDIUM/LOW] | [What the privacy issue is] | [How to fix it] |

> **If no privacy findings:** "No privacy findings identified. Implementation is privacy-compliant."

---

## Human Escalation Assessment

**Human sign-off required:** YES / NO

**Reason (if YES):**
- [ ] RESTRICTED data handling without prior approval
- [ ] LGPD/GDPR compliance determination needed
- [ ] Cross-border data transfer identified
- [ ] Third-party DPA missing or unclear
- [ ] Data breach risk identified

**If human sign-off required:** Issue `BLOCKED_PENDING_HUMAN` and escalate to Tech Lead immediately.

---

## Privacy Assessment Sign-off

- [ ] Data classification complete for all entities
- [ ] Legal basis documented for all CONFIDENTIAL/RESTRICTED processing
- [ ] Data minimization verified — no unnecessary fields collected
- [ ] Consent mechanism implemented (if required)
- [ ] Deletion support configured (CASCADE or anonymization)
- [ ] Third-party DPAs verified
- [ ] No PII in audit_log or sync_log
- [ ] Human escalation issued if RESTRICTED data present
