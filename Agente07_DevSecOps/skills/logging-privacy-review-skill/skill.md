# Skill: logging-privacy-review-skill

## Purpose

Audit all `audit_log` and `sync_log` write calls for PII exposure, incorrect actorEmail sourcing, and log injection risks. Every Gate 5 evaluation requires this review.

## When to Use

Every Gate 5 evaluation — mandatory.

## Inputs

- All files containing audit_log or sync_log write calls
- audit_log schema (from context_view.md section 6)
- Data classification results (to understand which fields are CONFIDENTIAL)

## Outputs

- Logging privacy report: PASS or FAIL per log call site
- CRITICAL findings if passwords/tokens logged
- HIGH findings (BLOCKED_PRIVACY_VIOLATION) if raw PII in log fields

## Constraints

- Every audit_log call must be reviewed field-by-field — not just checked for presence
- `actorEmail` MUST come from `session.user.email` — not from request or input
- `metadata` field: allowed value types are `string`, `number`, and `boolean` only — no nested objects, no arrays, no `null` values; keys must be snake_case identifiers; values must not be raw user input (e.g., do not log `comment: rawInput.comment`) — use entity IDs and operation codes instead; example allowed: `{ entity_id: "uuid", action_count: 3, is_batch: false }`

## Steps

1. Find all audit_log.create() calls
2. For each: inspect every field and metadata key-value pair
3. Find all sync_log calls — verify no user-identifying data
4. Find all console.log/error/warn — check for PII or token exposure
5. Classify findings and report

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR005
- `Agente07_DevSecOps/knowledge/knowledge_cards.md` → Card 010 (audit_log Schema)
- `Agente07_DevSecOps/knowledge/heuristics.md` → H7, H12
- `Agente07_DevSecOps/checklists/logging_privacy_checklist.md`

Do NOT access `context/` or `lib/` at runtime.
