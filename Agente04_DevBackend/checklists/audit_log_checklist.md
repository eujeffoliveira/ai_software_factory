# Audit Log Checklist

**When to run:** For every Server Action that creates, updates, or deletes user data.  
**Purpose:** Ensure compliance audit trail — no sensitive mutations go unrecorded.

---

## Coverage

- [ ] Every Server Action with a CREATE operation calls `auditLog()` after success
- [ ] Every Server Action with an UPDATE operation calls `auditLog()` after success
- [ ] Every Server Action with a DELETE operation calls `auditLog()` after success
- [ ] Approval, rejection, status-change, and permission-change operations call `auditLog()`
- [ ] Audit entry is NOT added for read-only operations (GET, list, search)

## Call Position

- [ ] `auditLog()` is called AFTER the successful DB operation — not before, not in the catch block
- [ ] If the DB operation fails (catch block), `auditLog()` is NOT called
- [ ] `auditLog()` is inside the `try` block — after the result is obtained

## Actor Identity

- [ ] `actorId` sourced from `session.user.id` — never from request body or input
- [ ] `actorEmail` sourced from `session.user.email` — never from request body or input
- [ ] Both `actorId` and `actorEmail` are non-null/non-undefined before the call

## Action Verb Format

- [ ] `action` field uses PAST_TENSE_VERB in SCREAMING_SNAKE_CASE
  - Correct: `"TASK_CREATED"`, `"STATUS_UPDATED"`, `"RECORD_DELETED"`
  - Wrong: `"CREATE_TASK"`, `"create"`, `"taskCreated"`
- [ ] Action verb accurately describes the operation (not generic `"CHANGED"`)
- [ ] Action verb is unique for each distinct operation type

## Entity Reference

- [ ] `entityType` matches the Prisma model name exactly (e.g., `"Task"`, `"Project"`, `"User"`)
- [ ] `entityId` is the ID of the AFFECTED record — not the actor's ID
- [ ] For bulk operations, `auditLog()` is called for each affected record individually

## Metadata

- [ ] `metadata` object includes relevant context for debugging and compliance
- [ ] `metadata` does NOT contain: passwords, tokens, full auth sessions, payment card numbers
- [ ] `metadata` uses only scalar values or simple objects — no circular references
- [ ] `metadata` size is reasonable (no entire large objects)

---

## Audit Log Function Signature Reference

```typescript
await auditLog({
  actorId: session.user.id,        // from session — REQUIRED
  actorEmail: session.user.email ?? "",  // from session — REQUIRED
  action: "ENTITY_CREATED",        // PAST_TENSE_VERB — REQUIRED
  entityType: "EntityName",        // Prisma model name — REQUIRED
  entityId: result.id,             // the affected record ID — REQUIRED
  metadata: {                      // operation context — OPTIONAL
    title: result.title,
    previousStatus: oldStatus,
  },
})
```

---

## Approved Action Verb List

| Action | When to Use |
|--------|-------------|
| `CREATED` | Record created for the first time |
| `UPDATED` | Record fields modified |
| `DELETED` | Record removed |
| `APPROVED` | Record moved to approved/active state |
| `REJECTED` | Record moved to rejected/denied state |
| `PUBLISHED` | Record made visible/public |
| `ARCHIVED` | Record moved to archive |
| `RESTORED` | Record restored from archive or deleted state |
| `TRANSFERRED` | Ownership transferred to another user |
| `INVITED` | User invited to resource/team |
| `REVOKED` | Permission or access revoked |

For domain-specific verbs not in this list, use the pattern: `[NOUN]_[PAST_TENSE_VERB]` (e.g., `SUBSCRIPTION_CANCELLED`, `PAYMENT_PROCESSED`).

---

## Runtime Knowledge Policy

This checklist is part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, or global architecture documents.  
All required patterns are in `context_view.md §8`, `knowledge/decision_rules.md` (DR003), and `knowledge/knowledge_cards.md` (Card 005).
