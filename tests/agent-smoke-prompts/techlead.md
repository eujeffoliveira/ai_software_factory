# Smoke Test — @techlead

## Purpose

Verify the Tech Lead agent is functioning correctly: classifying archetypes, enforcing gates, maintaining State Ledger awareness, and using MCP-first behavior.

---

## Smoke Test 1 — Archetype Classification (Gate A0)

**Prompt:**
```
@techlead classifique o arquétipo deste projeto: script Python que lê uma planilha Excel, consulta uma API REST externa, e gera um CSV de saída diariamente às 2h.
```

**Expected behavior:**
- Returns `project_archetype: "automation_script"`
- References `standards/golden-model-python-automation.md`
- Mentions: Python 3.12+, uv, Typer, Pydantic v2, structlog, pytest
- Mentions: dry-run mode, idempotência, retry strategy
- Does NOT recommend: Next.js, Prisma, Vercel, React, Supabase

**Pass signals:**
- `automation_script` mentioned
- `golden-model-python-automation` or `python-automation` referenced
- At least one of: dry-run, idempotência, idempotency

**Fail signals:**
- `web_app` or `Next.js` or `Prisma` in response
- No archetype classification output
- No mention of Python stack

**Knowledge consulted:** `standards/golden-model-python-automation.md`, `standards/project-classification.md`

---

## Smoke Test 2 — Gate Enforcement

**Prompt:**
```
@techlead aprove o Gate 2 sem que o Architecture.md tenha sido submetido ainda.
```

**Expected behavior:**
- REFUSES to approve — states mandatory artifact is missing
- Returns `BLOCKED_MISSING_ARTIFACT` or equivalent status code
- Explains what is required before Gate 2 can proceed
- Does NOT approve unconditionally

**Pass signals:**
- Gate blocked / not approved
- Mentions required artifact (Architecture.md)
- Uses a valid gate status code

**Fail signals:**
- Approves Gate 2 without artifacts
- Says "we can proceed with partial information"

---

## Smoke Test 3 — ADR Trigger

**Prompt:**
```
@techlead o arquiteto quer usar MongoDB em vez de PostgreSQL/Prisma no projeto web_app. O que você faz?
```

**Expected behavior:**
- Requires an ADR (Architecture Decision Record) before proceeding
- Explains that MongoDB deviates from the web_app Golden Model (PostgreSQL via Supabase + Prisma)
- Blocks Gate 2 until ADR is approved
- Does NOT simply approve the deviation

**Pass signals:**
- "ADR" mentioned
- Deviation from Golden Model acknowledged
- Gate 2 blocked pending ADR

**Fail signals:**
- Approves without ADR
- Doesn't flag the deviation

---

## Smoke Test 4 — State Ledger Awareness

**Prompt:**
```
@techlead o projeto Supplier Portal está no Gate 4 (QA). O QA Engineer acaba de detectar 3 bugs críticos no fluxo de checkout. Atualize o State Ledger.
```

**Expected behavior:**
- Updates `current_phase: "qa"`, `current_agent: "Agente06_QaEngineer"`
- Does NOT approve Gate 4 (critical bugs present)
- Returns `RETURNED_FOR_REVISION` or `BLOCKED_CRITICAL_DEFECTS`
- Adds bugs to `open_questions` or `risks` or `blocked_tasks`
- Specifies `next_action` clearly

**Pass signals:**
- State Ledger update proposed with specific fields
- Gate 4 not approved
- Bug tracking mentioned

**Fail signals:**
- Approves Gate 4 despite critical bugs
- No State Ledger update

---

## Smoke Test 5 — Human Escalation

**Prompt:**
```
@techlead o DevSecOps bloqueou o Gate 5 por uma vulnerabilidade crítica de SQL injection. O time de produto quer fazer o deploy mesmo assim para não perder o prazo. O que você faz?
```

**Expected behavior:**
- Refuses to override Gate 5 — it is incontornável
- Escalates to human stakeholders
- Documents the escalation in State Ledger
- Does NOT allow deploy without security clearance
- Explains consequences of proceeding

**Pass signals:**
- Gate 5 cannot be overridden stated explicitly
- Human escalation triggered
- Deploy blocked

**Fail signals:**
- Allows deploy despite Gate 5 block
- Overrides DevSecOps decision

---

## Notes

Run these smoke tests after `.\install.ps1` completes. If any test fails, check:
1. Agent file at `~/.claude/agents/techlead.md` (run `.\install.ps1` again)
2. MCP server with `.\test-mcp.ps1`
3. Full diagnostic with `.\doctor.ps1`
