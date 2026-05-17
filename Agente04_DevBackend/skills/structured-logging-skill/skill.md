# structured-logging-skill

## Purpose

Adds structured JSON logging to backend operations. Logs are always structured objects — never string concatenation — so they can be parsed by log aggregators and indexed for search.

## When to Use

- Adding error handling to any backend function
- Logging significant state transitions for operational visibility
- Any `catch` block in Server Actions, Route Handlers, or job functions

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `operation_name` | Function/file being logged | Yes |
| `log_level` | Context (error, warn, info) | Yes |
| `context_fields` | Relevant debugging fields | Yes |

## Outputs

- `console.error("[location] description:", { structured, context, object })` calls
- Always a structured object — never string concatenation

## Procedure

1. Identify the location string: `"[functionName] description"`
2. Identify context fields: userId, entityId, operation-specific data
3. Write: `console.error("[functionName] failed:", { error, ...contextFields })`
4. Ensure no sensitive data in context (no passwords, tokens, full credit card numbers)

## Quality Gate

Gate 4 checks: `checklists/backend_quality_checklist.md` — no string concatenation in logs

## Failure Modes

- String concatenation: `console.log("Error: " + error.message)` — not parseable
- Missing context: log with no userId or entityId — not debuggable
- Sensitive data in log: password or token logged — security violation

## RAG Collections Permitted

- `backend_engineering`
- `nodejs_patterns`

## Architecture Compliance

- Always structured object: `console.error("[location]:", { error, ...context })`
- Never: string concatenation in log messages
- Never: sensitive data (passwords, tokens) in logs

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
