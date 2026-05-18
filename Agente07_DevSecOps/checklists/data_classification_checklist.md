# Data Classification Checklist

> Run this checklist as Step 2 of every Gate 5 evaluation (before all other skills). The classification result drives the scope and depth of the privacy review.

## Runtime Knowledge Policy

Read from `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 009 — Data Classification Tiers) and `Agente07_DevSecOps/knowledge/decision_rules.md` (DR012) before executing. Do NOT access `context/` or `lib/` at runtime.

---

## Step 1: Identify All Data Entities

From `Architecture.md`, `prisma/schema.prisma`, and `API_Contract.json`, list all data entities touched by the feature:

- [ ] Database tables in `prisma/schema.prisma` that are read or written
- [ ] Fields within those tables that are used (not just present in schema)
- [ ] API response shapes that contain user data
- [ ] Log entries (audit_log, sync_log) that are written
- [ ] Data received from or sent to external APIs

---

## Step 2: Apply Classification Tier

For each entity, apply the four-tier classification:

**RESTRICTED criteria (any of these → RESTRICTED):**
- Health data, medical records, diagnoses
- Financial data: credit card numbers, bank account details, transaction history
- Government-issued IDs: social security, tax ID, passport numbers
- Biometric data
- Data regulated by specific laws (HIPAA, PCI-DSS, specific national laws)
- Any data whose exposure causes irreversible harm

**CONFIDENTIAL criteria (any of these → CONFIDENTIAL if not RESTRICTED):**
- User email addresses
- User display names or full names
- User profile information: avatar, bio, preferences
- Behavioral data: usage patterns, feature usage, session data
- User-generated content associated with an identified user
- IP addresses associated with a specific user
- Any data the user would consider personal

**INTERNAL criteria (not CONFIDENTIAL or RESTRICTED):**
- Internal identifiers (UUIDs, auto-incremented IDs)
- Timestamps of system events
- Organization-level configuration settings
- Aggregate counts and statistics
- Business logic rules and thresholds
- Non-identifying labels and categories

**PUBLIC criteria (safe for unrestricted access):**
- Marketing content
- Public feature descriptions
- UI labels and copy
- Publicly documented product information
- Aggregate statistics with no individual attribution

---

## Step 3: Classification Table

| Entity ID | Entity Name | Entity Type | Classification | PII Fields | Regulatory Obligations | Rationale |
|-----------|------------|------------|---------------|-----------|----------------------|-----------|
| E-01 | | TABLE/FIELD/API/LOG | PUBLIC/INTERNAL/CONFIDENTIAL/RESTRICTED | [list] | [list] | [why] |

---

## Step 4: Identify Highest Tier

- [ ] Scan classification table — what is the highest tier found?
- [ ] Record: `highest_tier` = [PUBLIC / INTERNAL / CONFIDENTIAL / RESTRICTED]
- [ ] The highest tier controls the review scope for the entire feature

---

## Step 5: Take Immediate Action Based on Highest Tier

**If highest_tier = RESTRICTED:**
- [ ] Issue `BLOCKED_PENDING_HUMAN` immediately
- [ ] Escalate to Tech Lead: "RESTRICTED data identified — human sign-off required before processing decision"
- [ ] Do NOT continue privacy assessment until human sign-off is documented
- [ ] `restricted_human_signoff_required: true`

**If highest_tier = CONFIDENTIAL:**
- [ ] Proceed with `privacy-review-skill` (Section 3 of workflow)
- [ ] `privacy_review_required: true`
- [ ] No human sign-off required at classification stage (may be required in privacy review)

**If highest_tier = INTERNAL or PUBLIC:**
- [ ] Privacy review of limited scope (verify no PII in logs, no accidental PII exposure in API responses)
- [ ] `privacy_review_required: false` (logging privacy review still required)

---

## Data Classification Summary

| Tier | Count | Human Sign-off Required | Privacy Review Required |
|------|-------|------------------------|------------------------|
| RESTRICTED | [N] | YES / NO | YES |
| CONFIDENTIAL | [N] | Maybe | YES |
| INTERNAL | [N] | NO | NO (log check only) |
| PUBLIC | [N] | NO | NO |

**Highest tier found:** [tier]
**`restricted_human_signoff_required`:** true / false
**`privacy_review_required`:** true / false
**Immediate action taken:** [BLOCKED_PENDING_HUMAN issued / Proceed to privacy-review-skill / Log check only]
