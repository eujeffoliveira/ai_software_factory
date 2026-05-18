# Security Blockers

## Gate 5 Status: [BLOCKED_CRITICAL_RISK | BLOCKED_SECRET_EXPOSED | BLOCKED_AUTH_BYPASS | BLOCKED_PRIVACY_VIOLATION | BLOCKED_PENDING_HUMAN]

**Project:** [Project Name]
**Feature/PR:** [Feature description]
**Blocker Date:** [YYYY-MM-DD]
**Issued by:** Agente07_DevSecOps v1.0.0
**Total Blockers:** [N CRITICAL, N HIGH]

> This document summarizes the security blockers that prevent Gate 5 approval. For detailed remediation instructions per blocker, see `Remediation_Guide.md`. All blockers must be resolved and a re-audit conducted before Gate 5 can be re-evaluated.

---

## Critical Blockers (Gate 5 cannot advance)

### SEC-001 — [Blocker Title]

**Severity:** CRITICAL
**Gate Status Triggered:** [BLOCKED_SECRET_EXPOSED | BLOCKED_AUTH_BYPASS | BLOCKED_CRITICAL_RISK | BLOCKED_PRIVACY_VIOLATION | BLOCKED_PENDING_HUMAN]
**OWASP Category:** [A01 | A02 | A03 | A04 | A05 | A06 | A07 | A08 | A09 | A10]
**Location:** `[file path]:[line number]`
**Decision Rule:** DR00N
**Responsible Agent:** Agente0X_DevXxx

**Description:**
[Precise description of the vulnerability. What it is, where it is, what the impact is, and why it is a gate blocker. Include the specific code pattern found.]

**Vulnerable Code:**
```typescript
// Found at [file]:[line]
[code snippet showing the vulnerability]
```

**Impact:** [Specific impact — e.g., "Any unauthenticated HTTP caller can trigger this route and execute all pending jobs."]

**Escalation Required:** YES / NO
**Secret Rotation Required:** YES / NO

---

### SEC-002 — [Blocker Title]

[Repeat format for each CRITICAL blocker]

---

## High Blockers (must remediate before APPROVED)

### SEC-00N — [Blocker Title]

**Severity:** HIGH
**OWASP Category:** [AXX]
**Location:** `[file path]:[line number]`
**Decision Rule:** DR00N
**Responsible Agent:** Agente0X_DevXxx

**Description:**
[Description of the HIGH finding.]

**Impact:** [Specific impact]

---

## Systemic Patterns

[If the same vulnerability class is found in 3+ locations (DR015), document here]

> **If no systemic patterns:** "No systemic vulnerability patterns detected."

| Pattern | Occurrences | Recommendation |
|---------|-------------|---------------|
| [Pattern description e.g., "Missing auth() check"] | [N locations] | [Recommendation — e.g., "Search the entire codebase for Server Actions without auth() as first call; implement a linting rule"] |

---

## Escalation Actions Taken

| Action | Target | Date |
|--------|--------|------|
| Escalated CRITICAL findings | Agente00_TechLead | [date] |
| Secret rotation requested | Tech Lead | [date] |
| RESTRICTED data escalation | Tech Lead (for human sign-off) | [date] |

---

## Re-audit Requirements

Before Gate 5 can be re-evaluated:

1. **All CRITICAL blockers must be fixed** — code changed, secret rotated if applicable
2. **All HIGH blockers must be fixed** — or risk formally accepted by a human with documented approval
3. **Re-audit scope:** Full re-audit of all affected files (not only the changed lines)
4. **Resubmission package must include:**
   - Updated implementation files
   - Summary of all changes made per finding ID
   - Updated `package.json` if dependencies were changed
   - If secret was exposed: confirmation of secret rotation from Tech Lead

> DevSecOps will re-run all skills on resubmission, not just review the changed lines.
