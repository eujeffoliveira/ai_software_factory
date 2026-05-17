# Task: [TASK-NNN] — [Title]

---

## Task Metadata

| Field | Value |
|-------|-------|
| **Task ID** | TASK-NNN |
| **Title** | [Verb + Object in ≤ 8 words] |
| **Type** | [backend / frontend / database / infrastructure / testing / security / config] |
| **Layer** | [infrastructure / data-access / business-logic / api / presentation / testing / configuration] |
| **Status** | pending |
| **Estimated Complexity** | [S / M / L — XL is not allowed] |

---

## File Path

```
[exact/relative/path/to/file.ts]
```

> This task creates/modifies exactly ONE file. If more than one file is needed, create additional tasks.

---

## Description

[2-4 sentences describing:
1. What this task does
2. Why it is needed (what feature/requirement it supports)
3. Any important constraints or special considerations]

---

## Context (for L-complexity tasks only)

[Max 200 words. Describe:
- What already exists that this task builds on
- What other tasks have produced that this task consumes
- Key patterns or conventions to follow
- What NOT to do in this task]

---

## Function Signatures

Pre-specified signatures the dev agent must implement. Deviations require escalation to Tech Lead.

```typescript
// Primary export
[function/component signature]

// Supporting types
[type definitions if needed]
```

---

## Dependencies

| Depends On | Dependency Type | Reason |
|-----------|----------------|--------|
| TASK-XXX | sequential / data / file | [Why this task depends on TASK-XXX] |
| TASK-YYY | sequential / data / file | [Why this task depends on TASK-YYY] |

_If no dependencies: this task has no dependencies and can be started first._

---

## Acceptance Criteria

All criteria must be verified before this task is marked complete.

- [ ] [Criterion 1 — specific and testable]
- [ ] [Criterion 2 — specific and testable]
- [ ] [Criterion 3 — specific and testable]

> Criteria must be verifiable (can be checked by a test or code review). Avoid vague criteria like "it works correctly."

---

## Test Requirements

| Test Type | Required | Tool | Notes |
|-----------|----------|------|-------|
| Unit | [true/false] | Vitest | [Coverage target: N%] |
| Integration | [true/false] | Vitest | [What to test] |
| E2E | [true/false] | Playwright | [User flow to test] |

**Mock Requirements:**
- [What needs to be mocked, e.g., Prisma client, NextAuth session]

**Test Data Requirements:**
- [Fixtures, seed data, or test setup required]

---

## Security Requirements

| Requirement | Value | Notes |
|------------|-------|-------|
| Authentication required | [true/false] | |
| Authorization check | [true/false] | Level: [public/authenticated/role-based/admin] |
| Input validation (Zod) | [true/false] | Schema: `[ZodSchemaName]` |
| Audit log entry | [true/false] | Event: `[event.type]` |
| SQL injection risk | [true/false] | |
| XSS risk | [true/false] | |
| CSRF risk | [true/false] | |
| DevSecOps review | [true/false] | |

**Security Notes:**
[Specific security guidance for this task — what to verify, what patterns to use, what to avoid]

---

## Golden Path Constraints

Mandatory technology constraints from the Golden Path stack that apply to this task:

- [ ] [Golden Path rule relevant to this task type]
- [ ] [e.g., Use `prisma migrate deploy` — never `prisma db push`]
- [ ] [e.g., All env vars via `lib/env.ts` — never `process.env` directly]
- [ ] [e.g., Validate all inputs with Zod schema at function entry]
- [ ] [e.g., Write audit_log before returning from mutation]

---

## Notes for Developer

[Optional: any additional guidance, known edge cases, references to Architecture.md sections, or reminders that don't fit elsewhere]
