# Threat Model

## Feature: [Feature Name]
## Date: [YYYY-MM-DD]
## Produced by: Agente07_DevSecOps v1.0.0

---

## System Overview

[Brief description — what the feature does, who uses it, what data it handles, and why it requires threat modeling. 2-4 sentences.]

Example: "The User Profile Update feature allows authenticated users to update their display name, avatar URL, and notification preferences. It writes to the User table (CONFIDENTIAL data) and emits an audit_log entry. It is exposed as a Server Action accessed from the profile settings page."

---

## Trust Boundaries

Trust boundaries are points where data or control crosses from one trust domain to another. Every crossing must be validated.

| ID | Boundary | What Crosses It | Validation Required |
|----|----------|-----------------|-------------------|
| TB-01 | Browser → Next.js App Router | User input (form data, file uploads) | Zod schema validation |
| TB-02 | Server Action → Prisma DAL | Parsed, validated user data | Auth check + ownership scope |
| TB-03 | Prisma DAL → Supabase PostgreSQL | Parameterized queries | Prisma parameterization |
| TB-04 | [Add as needed] | [What crosses] | [Validation] |

---

## Assets

Assets are data and functionality worth protecting. Classify each asset.

| ID | Asset | Classification | Why Worth Protecting |
|----|-------|---------------|---------------------|
| A-01 | [User.email] | CONFIDENTIAL | PII — unauthorized disclosure harms users |
| A-02 | [User.id] | INTERNAL | Identity — used for authorization scoping |
| A-03 | [audit_log entries] | INTERNAL | Tamper-evident audit trail — repudiation risk |
| A-04 | [Add assets] | [PUBLIC/INTERNAL/CONFIDENTIAL/RESTRICTED] | [Reason] |

---

## Threat Analysis (STRIDE)

### S — Spoofing (impersonating another user or system)

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| S-01 | Attacker impersonates a user by bypassing session check | Server Action: updateProfile | HIGH | CRITICAL | `const session = await auth()` as FIRST operation; return 401 if null | IMPLEMENTED |
| S-02 | Attacker sends a crafted request claiming to be another userId | Input schema | MEDIUM | HIGH | Remove userId from input schema; source from session.user.id only | IMPLEMENTED |
| S-03 | [Add threats] | [Component] | [L/M/H] | [L/M/H/C] | [Mitigation] | [IMPLEMENTED/PARTIAL/MISSING] |

### T — Tampering (unauthorized modification of data or code)

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| T-01 | SQL injection via unvalidated user input | DAL queries | LOW (Prisma parameterizes) | CRITICAL | Prisma parameterized API only; no raw SQL | IMPLEMENTED |
| T-02 | Bypassing input validation to set unauthorized fields | Zod schema | MEDIUM | HIGH | Strict Zod schema with only allowed fields (no passthrough) | IMPLEMENTED |
| T-03 | [Add threats] | [Component] | [L/M/H] | [L/M/H/C] | [Mitigation] | [IMPLEMENTED/PARTIAL/MISSING] |

### R — Repudiation (denying an action was taken)

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| R-01 | User denies updating their profile | audit_log | LOW (logging present) | MEDIUM | audit_log entry on every profile update with actorId, action, entityId | IMPLEMENTED |
| R-02 | Log entry can be tampered with by app code | audit_log | LOW | HIGH | audit_log is append-only; no update/delete operations on audit entries | IMPLEMENTED |
| R-03 | [Add threats] | [Component] | [L/M/H] | [L/M/H/C] | [Mitigation] | [IMPLEMENTED/PARTIAL/MISSING] |

### I — Information Disclosure (unauthorized data exposure)

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| I-01 | User A reads User B's profile data (IDOR) | Prisma query | MEDIUM (if unscoped) | HIGH | Include `userId: session.user.id` in all Prisma where clauses | IMPLEMENTED |
| I-02 | Stack trace exposed in error response | catch block | MEDIUM | MEDIUM | Generic error messages only; details logged internally | IMPLEMENTED |
| I-03 | PII exposed in audit_log metadata | audit_log | MEDIUM | HIGH | metadata contains only field names, not values | IMPLEMENTED |
| I-04 | [Add threats] | [Component] | [L/M/H] | [L/M/H/C] | [Mitigation] | [IMPLEMENTED/PARTIAL/MISSING] |

### D — Denial of Service (degrading or halting service availability)

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| D-01 | Unbounded query returns excessive records | Prisma query | LOW | MEDIUM | Pagination and `take` limit on all list queries | IMPLEMENTED |
| D-02 | Oversized payload causes server exhaustion | Server Action input | LOW (Vercel limits) | MEDIUM | Zod schema enforces field length limits | IMPLEMENTED |
| D-03 | [Add threats] | [Component] | [L/M/H] | [L/M/H/C] | [Mitigation] | [IMPLEMENTED/PARTIAL/MISSING] |

### E — Elevation of Privilege (gaining higher access than authorized)

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| E-01 | User updates another user's profile (IDOR via URL param) | Server Action: updateProfile | MEDIUM | CRITICAL | Ownership check: where `{ id: profileId, userId: session.user.id }` | IMPLEMENTED |
| E-02 | User supplies admin role in request body to gain privileges | Input schema | MEDIUM | CRITICAL | Role never accepted from client; sourced from DB user record only | IMPLEMENTED |
| E-03 | [Add threats] | [Component] | [L/M/H] | [L/M/H/C] | [Mitigation] | [IMPLEMENTED/PARTIAL/MISSING] |

---

## Open Threats

Threats that are identified but not yet fully mitigated:

| ID | Description | Current Risk Level | Disposition | Notes |
|----|-------------|-------------------|-------------|-------|
| [ID] | [Description] | [LOW/MEDIUM/HIGH/CRITICAL] | ACCEPTED / ESCALATED / DEFERRED / MITIGATING_CONTROL_PLANNED | [Notes, timeline, owner] |

> **If no open threats:** "All identified threats have implemented mitigations. No open threats."

---

## Threat Model Sign-off

- [ ] All 6 STRIDE categories analyzed
- [ ] All trust boundaries documented
- [ ] All assets classified
- [ ] All threats have a mitigation or open-threat disposition
- [ ] MISSING mitigations for HIGH/CRITICAL impact threats are escalated
- [ ] Threat model reflects the current implementation (not the intended design)
