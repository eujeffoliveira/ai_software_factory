# Remediation Guide

## Gate 5 Decision: [BLOCKED_CRITICAL_RISK | BLOCKED_SECRET_EXPOSED | BLOCKED_AUTH_BYPASS | BLOCKED_PRIVACY_VIOLATION | RETURNED_FOR_REVISION | BLOCKED_PENDING_HUMAN]

**Project:** [Project Name]
**Feature/PR:** [Feature description]
**Audit Date:** [YYYY-MM-DD]
**Issued by:** Agente07_DevSecOps v1.0.0
**Target Agents:** [Agente04_DevBackend | Agente05_DevFrontend | Both]

> This guide provides specific, actionable remediation instructions for every finding in the Security Audit. For each finding: read the description, remove the wrong pattern, implement the correct pattern, then verify the fix resolves the finding as described. Do NOT attempt creative solutions — use the exact patterns shown. After all fixes are implemented, resubmit to DevSecOps for re-audit.

---

## Remediation Summary

| ID | Severity | Title | Responsible | Status |
|----|---------|-------|-------------|--------|
| SEC-001 | CRITICAL | [Title] | Agente04_DevBackend | PENDING |
| SEC-002 | HIGH | [Title] | Agente04_DevBackend | PENDING |
| SEC-003 | MEDIUM | [Title] | Agente05_DevFrontend | PENDING |

---

## SEC-001 — [Finding Title]

**Severity:** CRITICAL / HIGH / MEDIUM / LOW
**OWASP Category:** [AXX]
**Location:** `[file path]:[line number]`
**Decision Rule:** DR00N
**Responsible Agent:** Agente0X_DevXxx

### Problem

[Clear description of what is wrong and why it is a security risk. 2-4 sentences.]

### Wrong Pattern (remove this)

```typescript
// Location: [file path], line [N]
// This code is vulnerable because [reason]
[exact vulnerable code from the source file]
```

### Correct Pattern (replace with this)

```typescript
// Location: [file path], line [N]
// This is safe because [reason]
[correct code that replaces the wrong pattern]
```

### Additional Steps

1. [Any steps beyond the code change — e.g., "Rotate the exposed secret in the provider console before deploying the fix"]
2. [e.g., "Update lib/env.ts to include the new variable: `EXTERNAL_API_KEY: z.string().min(1)`"]
3. [e.g., "Verify .gitignore includes .env.local"]

### Verification

After implementing the fix, verify:
- [ ] The wrong pattern is no longer present in the file
- [ ] The correct pattern is in place and follows the exact structure shown
- [ ] [Any additional verification steps]

---

## SEC-002 — [Finding Title]

[Repeat format for each finding]

**Severity:** HIGH
**OWASP Category:** [AXX]
**Location:** `[file path]:[line number]`
**Decision Rule:** DR00N
**Responsible Agent:** Agente0X_DevXxx

### Problem

[Description]

### Wrong Pattern

```typescript
// [Code snippet]
```

### Correct Pattern

```typescript
// [Correct code]
```

### Additional Steps

1. [Step]

### Verification

- [ ] [Verification step]

---

## Systemic Recommendations

[If DR015 applies — same vulnerability found in 3+ places]

> **If no systemic issues:** "No systemic vulnerability patterns identified."

### Pattern: [e.g., "Missing auth() as first operation"]

**Found in:** [N] locations:
- `[file1]:[line]`
- `[file2]:[line]`
- `[file3]:[line]`

**Recommendation:**
1. Search the codebase for all Server Actions and Route Handlers
2. Verify every function has `const session = await auth()` as its absolute first operation
3. Consider implementing a shared wrapper utility that enforces the pattern
4. Consider adding an ESLint rule to flag functions in `app/api/` or `features/*/actions/` that do not start with `auth()`

---

## Resubmission Requirements

Before resubmitting to Gate 5:

**Required:**
- [ ] All CRITICAL findings fixed and confirmed
- [ ] All HIGH findings fixed (or risk formally accepted by human with written documentation)
- [ ] If a secret was exposed: confirmation that the secret has been rotated
- [ ] If RESTRICTED data involved: confirmation that human sign-off has been obtained

**Resubmission package must include:**
- [ ] Updated implementation files (all changed files, not just the specific lines)
- [ ] Summary of changes: list each finding ID and the change made to fix it
- [ ] If dependencies were changed: updated `package.json` and `package-lock.json`
- [ ] If secret was rotated: confirmation from Tech Lead (this agent does not verify rotation independently)

**Process:**
1. Implement all required fixes using the patterns shown in this guide
2. Self-review against `checklists/authz_checklist.md` and `checklists/secrets_checklist.md`
3. Resubmit to Gate 5 with the complete package described above
4. DevSecOps will conduct a full re-audit (not limited to the changed lines)

> Note: DevSecOps does not fix code. Only Dev agents (Agente04_DevBackend, Agente05_DevFrontend) implement fixes. This guide provides the guidance; the Dev agent implements it.
