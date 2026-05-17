# audit-log-implementation-skill — Execution Checklist

---

## Call Position

- [ ] `auditLog()` is inside the `try` block — not before it, not in catch
- [ ] `auditLog()` is AFTER the DAL/DB operation succeeds
- [ ] If operation throws, `auditLog()` is NOT called (no audit of failed operations)

## Field Values

- [ ] `actorId: session.user.id` — from session
- [ ] `actorEmail: session.user.email ?? ""` — from session
- [ ] `action` is PAST_TENSE_VERB in SCREAMING_SNAKE_CASE (e.g., `TASK_CREATED`)
- [ ] `entityType` matches Prisma model name exactly
- [ ] `entityId` is the ID of the affected record
- [ ] `metadata` contains relevant context without passwords, tokens, or non-audited PII

## Coverage

- [ ] Every CREATE operation has auditLog with ENTITY_CREATED action
- [ ] Every UPDATE operation has auditLog with ENTITY_UPDATED action
- [ ] Every DELETE operation has auditLog with ENTITY_DELETED action

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md §8`, `checklists/audit_log_checklist.md`, `knowledge/decision_rules.md` (DR003).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
