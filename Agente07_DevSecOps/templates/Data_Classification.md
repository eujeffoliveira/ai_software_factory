# Data Classification Report

## Feature: [Feature Name]
## Classification Date: [YYYY-MM-DD]
## Produced by: Agente07_DevSecOps v1.0.0
## Highest Tier Found: [PUBLIC | INTERNAL | CONFIDENTIAL | RESTRICTED]

> This classification drives the depth of the privacy review and determines whether human sign-off is required. The highest tier found controls the entire review — one RESTRICTED field means the full feature is reviewed at RESTRICTED tier.

---

## Classification Tier Reference

| Tier | Definition | Controls Required |
|------|------------|-------------------|
| PUBLIC | Non-sensitive data intended for broad access | Standard access control |
| INTERNAL | Organization-level data, internal IDs, business logic | Authenticated access; audit_log |
| CONFIDENTIAL | User PII: email, name, preferences, behavioral data | Encrypted storage; data minimization; consent; deletion support |
| RESTRICTED | Regulated data: health, financial, government IDs | All CONFIDENTIAL controls + human sign-off + LGPD/GDPR review + DPA if third-party |

---

## Entity Classification

| ID | Entity Name | Entity Type | Classification | PII Fields | Regulatory Obligations | Rationale |
|----|------------|------------|---------------|-----------|----------------------|-----------|
| E-01 | [User.email] | FIELD | CONFIDENTIAL | email | LGPD Art. 5(I); GDPR Art. 4(1) | Email is directly identifying PII |
| E-02 | [User.id] | FIELD | INTERNAL | none | None | Internal identifier; not PII by itself |
| E-03 | [Task.title] | FIELD | INTERNAL | none | None | User-created content but not directly identifying |
| E-04 | [Task.id] | FIELD | INTERNAL | none | None | Internal identifier |
| E-05 | [audit_log entry] | TABLE | INTERNAL | actorEmail (from session) | None | Operational audit data; actorEmail is controlled field |
| E-06 | [Add entities] | [TYPE] | [TIER] | [fields] | [obligations] | [rationale] |

---

## Fields by Classification Tier

### RESTRICTED Fields

> **If any RESTRICTED fields found: `restricted_human_signoff_required: true` — issue BLOCKED_PENDING_HUMAN immediately.**

| Field | Entity | Why RESTRICTED |
|-------|--------|---------------|
| [field] | [entity] | [health/financial/government ID/regulated] |

> **If no RESTRICTED fields:** "No RESTRICTED data entities identified in this feature."

### CONFIDENTIAL Fields

| Field | Entity | PII Type | Legal Basis Available |
|-------|--------|---------|----------------------|
| [User.email] | User | Email address (directly identifying) | [e.g., "Contract — service agreement"] |
| [User.displayName] | User | Name (directly identifying) | [e.g., "Consent — onboarding form"] |

> **If no CONFIDENTIAL fields:** "No CONFIDENTIAL data entities identified. Privacy review at INTERNAL tier."

### INTERNAL Fields

[List INTERNAL entities briefly — these do not require privacy review beyond authenticated access and audit logging]

### PUBLIC Fields

[List PUBLIC entities — these are accessible to all and have no privacy requirements]

---

## Privacy Review Triggered

Based on the highest classification tier found:

| Action | Required |
|--------|---------|
| Privacy review (privacy-review-skill) | YES (CONFIDENTIAL or RESTRICTED found) / NO |
| Human sign-off (BLOCKED_PENDING_HUMAN) | YES (RESTRICTED found) / NO |
| Consent documentation check | YES (CONFIDENTIAL found) / NO |
| Deletion support check | YES (CONFIDENTIAL found) / NO |
| Data Processing Agreement review | YES (third-party sharing of CONFIDENTIAL/RESTRICTED) / NO |

---

## Human Sign-off Status

**Required:** YES / NO

[If YES]:
- **Escalation issued to:** Agente00_TechLead on [date]
- **Human sign-off received:** YES / PENDING
- **Approval reference:** [document or message reference]
- **Approved by:** [human name / role]
- **Approval date:** [date]

---

## Classification Notes

[Any notes on ambiguous classifications, fields that required judgment, or fields where regulatory obligations were unclear.]

> Example: "User.metadata is classified as CONFIDENTIAL because it may contain user-defined tags that include PII. Even though the schema type is JSON and the values are unstructured, the potential for PII mandates CONFIDENTIAL treatment."
