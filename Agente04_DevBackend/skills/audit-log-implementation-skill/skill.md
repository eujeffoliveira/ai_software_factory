# audit-log-implementation-skill

## Purpose

Adds `auditLog()` entries for sensitive human actions. Every Server Action that creates, updates, or deletes data on behalf of a user must record an immutable audit entry AFTER the successful operation.

## When to Use

- Any Server Action with a CREATE operation
- Any Server Action with an UPDATE operation
- Any Server Action with a DELETE operation
- Any Server Action that changes status, approves, rejects, or transfers ownership

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `action_verb` | Task spec / PAST_TENSE_VERB list | Yes |
| `entity_type` | Prisma model name | Yes |
| `trigger_location` | File and function path | Yes |
| `metadata_fields` | Fields to include (no PII) | Yes |

## Outputs

- `auditLog({ actorId, actorEmail, action, entityType, entityId, metadata })` call
- AFTER the successful DB operation — inside `try` block

## Procedure

1. Identify the `action_verb` in PAST_TENSE_VERB format
2. Identify `entityType` (Prisma model name)
3. Place `await auditLog(...)` AFTER the `dal.operation()` call
4. Source `actorId` and `actorEmail` from `session` — never from `input`
5. Include relevant `metadata` without PII (except what's audited by policy)

## Quality Gate

Gate 4 checks: `checklists/audit_log_checklist.md`

## Failure Modes

- FM-07: `auditLog()` missing for CREATE/UPDATE/DELETE
- FM-07 variant: Called before operation (audit entry for failed operation)
- FM-07 variant: `actorId` from request body (can be spoofed)

## RAG Collections Permitted

- `backend_engineering`
- `architecture_reference_backend_view`

## Architecture Compliance

- MUST be called AFTER successful DB operation
- actorId/actorEmail MUST come from session
- action MUST be PAST_TENSE_VERB in SCREAMING_SNAKE_CASE
- Required for ALL CREATE/UPDATE/DELETE on user data — no exceptions

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
