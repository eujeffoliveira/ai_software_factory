# Logging Privacy Checklist

> Run this checklist on every Gate 5 evaluation. PII in logs = HIGH finding, BLOCKED_PRIVACY_VIOLATION. Password or token in logs = CRITICAL.

## Runtime Knowledge Policy

Read from `Agente07_DevSecOps/knowledge/decision_rules.md` (DR005), `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 010 — audit_log Schema) before executing. Do NOT access `context/` or `lib/` at runtime.

---

## Step 1: Identify All Log Call Sites

- [ ] Find all `prisma.auditLog.create()` calls (or equivalent audit_log write calls)
- [ ] Find all `sync_log` write calls in cron job routes
- [ ] Find all `console.log()`, `console.error()`, `console.warn()` calls in production code
- [ ] List all log call sites with file:line references

---

## Step 2: audit_log Field Audit

For each `audit_log` entry creation, verify field-by-field:

### Allowed Fields in audit_log
- [ ] `actorId` — must be `session.user.id` (internal ID, not PII)
- [ ] `actorEmail` — must be `session.user.email` (from session, not from request body or input)
- [ ] `action` — must be a string constant (e.g., `"task.create"`) — NOT user-supplied
- [ ] `entityType` — must be a string constant (e.g., `"Task"`) — NOT user-supplied
- [ ] `entityId` — must be an internal ID (string/number) — NOT user-supplied content
- [ ] `metadata` — must contain only safe identifiers (see below)
- [ ] `createdAt` — database-generated, not manually set

### Forbidden in audit_log metadata
- [ ] Raw email addresses or phone numbers as values
- [ ] User-supplied names or display names as values
- [ ] Request body content or form field values
- [ ] Passwords, tokens, or API keys (CRITICAL if found)
- [ ] Full JSON blobs of user input
- [ ] Stack traces or error messages

### audit_log Verification Table
| Call Site | actorId Source | actorEmail Source | metadata Safe | Status |
|-----------|---------------|------------------|--------------|--------|
| [file:line] | session.user.id ✅ / ❌ request | session.user.email ✅ / ❌ request | ✅ / ❌ | ✅ / ❌ |

---

## Step 3: sync_log Field Audit

For each `sync_log` entry (cron job result logging), verify:

- [ ] `action` — string constant describing the job (e.g., `"sync_invoices"`)
- [ ] `status` — `"SUCCESS"` or `"FAILURE"` or similar constant
- [ ] `count` — numeric count of records processed (safe — not PII)
- [ ] `duration_ms` — numeric duration (safe)
- [ ] `error` — if present, must be a generic error message or error type string — NOT the full error object with message
- [ ] No user data fields — sync_log does not record which specific users were affected (use audit_log for user-specific events)
- [ ] No email addresses, user names, or IDs of specific individuals in sync_log

| Call Site | Fields Present | User Data Found | Status |
|-----------|---------------|----------------|--------|
| [file:line] | [list fields] | YES / NO | ✅ / ❌ |

---

## Step 4: Console.log / Error Log Audit

For each `console.log()`, `console.error()`, `console.warn()` in production code:

- [ ] **No request body content**: `console.log(request.body)` or `console.log(parsedInput)` is a privacy risk if input contains PII
- [ ] **No user objects**: `console.log(user)` logs the full user object including email and PII fields
- [ ] **No session content**: `console.log(session)` logs the session which may include personal data
- [ ] **Error logging safe**: `console.error(error)` is acceptable; `console.error(error.message, userData)` is not
- [ ] **No tokens in logs**: `console.log(token)` or `console.log(apiKey)` — CRITICAL if found

| File | Log Call | Content Logged | PII Risk | Status |
|------|----------|---------------|---------|--------|
| [file:line] | console.error | error object only | LOW | ✅ |
| [file:line] | console.log | user object | HIGH | ❌ |

---

## Step 5: Log Injection Check

- [ ] **No user input in log strings**: User-supplied strings not interpolated directly into log messages (log injection risk)
- [ ] **Structured logging**: Logs use structured objects (`{ action: "...", entityId: "..." }`) not interpolated strings

---

## Logging Privacy Summary

| Check | Call Sites Reviewed | Issues Found | Status |
|-------|--------------------|-----------|-|
| audit_log actorId source | [N] | [N] | ✅ / ❌ |
| audit_log actorEmail source | [N] | [N] | ✅ / ❌ |
| audit_log metadata PII | [N] | [N] | ✅ / ❌ |
| sync_log fields | [N] | [N] | ✅ / ❌ |
| console.log PII | [N] | [N] | ✅ / ❌ |
| Passwords/tokens in logs | [N] | [N] | ✅ / ❌ |

**Overall logging privacy status:** PASS / FAIL
**Findings (if any):** [List with SEC-NNN IDs and severity]
