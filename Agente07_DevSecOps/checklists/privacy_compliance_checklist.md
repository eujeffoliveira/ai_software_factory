# Privacy Compliance Checklist

> Run this checklist after `data-classification-skill` for any feature handling CONFIDENTIAL or RESTRICTED data. Escalate immediately if RESTRICTED data is found.

## Runtime Knowledge Policy

Read from `Agente07_DevSecOps/knowledge/principles.md` (P8, P12), `Agente07_DevSecOps/knowledge/decision_rules.md` (DR005, DR012), and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 008, Card 009) before executing. Do NOT access `context/` or `lib/` at runtime.

---

## Pre-check: Data Classification Input

- [ ] `data-classification-skill` has been executed
- [ ] Highest classification tier is known: [PUBLIC / INTERNAL / CONFIDENTIAL / RESTRICTED]
- [ ] If RESTRICTED: immediately issue `BLOCKED_PENDING_HUMAN` and escalate before proceeding

---

## Section 1: Legal Basis for Data Processing

**Applicable to:** Features collecting, storing, or processing CONFIDENTIAL or RESTRICTED data

- [ ] **Legal basis identified**: Processing has a documented legal basis (consent, contract, legal obligation, or legitimate interest)
- [ ] **Documented in PRD**: The legal basis is referenced in the PRD or Architecture.md
- [ ] **Consent mechanism implemented**: If consent is the legal basis, consent is collected and recorded before data is processed
- [ ] **Consent withdrawal supported**: Users can withdraw consent (right to object — LGPD Art. 18; GDPR Art. 21)

**Status:** ✅ PASS / ❌ FAIL / N/A
**Notes:** [What legal basis was found or what is missing]

---

## Section 2: Data Minimization

**Applicable to:** All features collecting user data

- [ ] **Only necessary fields collected**: Form inputs, API request schemas, and Prisma models collect only fields required for the stated purpose
- [ ] **No "just in case" fields**: No fields added for possible future use without current necessity
- [ ] **Zod schema validation**: Input schemas use strict validation (no `.passthrough()` on PII-containing schemas)
- [ ] **Response data minimized**: API responses do not return unnecessary PII fields (e.g., returning full User object when only name is needed)

**Status:** ✅ PASS / ❌ FAIL
**Unnecessary fields found:** [List or "None"]

---

## Section 3: Purpose Limitation

**Applicable to:** Features that process CONFIDENTIAL or RESTRICTED data

- [ ] **Data used only for stated purpose**: CONFIDENTIAL data collected for purpose X is not also used for purpose Y without disclosure
- [ ] **No secondary use without consent**: User email collected for login is not used for marketing without separate consent
- [ ] **Purpose documented**: The purpose of data collection is documented in the PRD or privacy notice

**Status:** ✅ PASS / ❌ FAIL / N/A
**Notes:** [Specific concerns if any]

---

## Section 4: Data Retention and Deletion (Right to Erasure)

**Applicable to:** Features that store CONFIDENTIAL data

- [ ] **Retention policy defined**: How long is data retained? Is there an automated expiry?
- [ ] **Hard delete or anonymization**: User data can be deleted or anonymized on request
- [ ] **Cascade delete configured**: Prisma schema has `onDelete: Cascade` for user-owned records
- [ ] **Soft delete consideration**: If soft delete is used, does it anonymize PII fields rather than just setting `deletedAt`?
- [ ] **Right to erasure tested**: Is there a mechanism for users or admins to trigger deletion of a user's data?

```prisma
// Expected cascade pattern for user-owned data:
model UserRecord {
  userId String
  user   User   @relation(fields: [userId], references: [id], onDelete: Cascade)
}
```

**Status:** ✅ PASS / ❌ FAIL / N/A
**Notes:** [Missing deletion support details if FAIL]

---

## Section 5: Third-Party Data Sharing

**Applicable to:** Features that send user data to external services

- [ ] **Third parties identified**: List every external service that receives CONFIDENTIAL or RESTRICTED user data
- [ ] **DPA in place**: A Data Processing Agreement exists with every third party receiving user data
- [ ] **Data transfer documented**: What data is shared, why, and under what legal basis is documented
- [ ] **Cross-border transfers addressed**: If data is transferred internationally, appropriate safeguards are in place

| Third Party | Data Shared | DPA Present | Notes |
|------------|------------|-------------|-------|
| [service] | [data fields] | YES / NO / N/A | [notes] |

**Status:** ✅ PASS / ❌ FAIL / N/A

---

## Section 6: Data Subject Rights Support

**Applicable to:** Features storing CONFIDENTIAL or RESTRICTED data

- [ ] **Right to access**: Can the organization provide a user with all data held about them?
- [ ] **Right to rectification**: Can users correct inaccurate personal data?
- [ ] **Right to erasure**: Can users request deletion of their data?
- [ ] **Right to portability**: Can users export their data in a machine-readable format?
- [ ] **Right to object**: Can users opt out of processing?

**Status:** ✅ PASS / ❌ FAIL (partial) / N/A
**Notes:** [Which rights are supported and which are missing]

---

## Section 7: Privacy Incident Preparedness

**Applicable to:** All features handling CONFIDENTIAL or RESTRICTED data

- [ ] **Incident response plan exists**: Organization has a documented data breach response procedure
- [ ] **Notification obligation understood**: Breach notification to regulators within 72 hours (LGPD Art. 48; GDPR Art. 33) is documented
- [ ] **No production PII in dev/test**: Dev and test environments do not use real production user data

**Status:** ✅ PASS / ❌ FAIL / N/A / ASSUMED
**Notes:** [What is known and what must be escalated]

---

## Privacy Compliance Summary

| Check | Status |
|-------|--------|
| Legal basis documented | ✅ PASS / ❌ FAIL / N/A |
| Data minimization verified | ✅ PASS / ❌ FAIL |
| Purpose limitation confirmed | ✅ PASS / ❌ FAIL / N/A |
| Deletion support configured | ✅ PASS / ❌ FAIL / N/A |
| Third-party DPAs verified | ✅ PASS / ❌ FAIL / N/A |
| Data subject rights supported | ✅ PASS / ❌ FAIL / N/A |
| Incident preparedness confirmed | ✅ PASS / ❌ FAIL / ASSUMED |

**Overall privacy compliance status:** COMPLIANT / NON_COMPLIANT / PENDING_HUMAN / NOT_APPLICABLE

**Human escalation required:** YES / NO
**Escalation reason:** [If YES, why human sign-off is needed]
