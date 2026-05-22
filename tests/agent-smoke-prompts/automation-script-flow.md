# Smoke Test — Automation Script End-to-End Flow

## Purpose

Verify that the full factory flow for an automation_script archetype correctly refuses to use the web_app stack and follows the Python automation golden model from Gate A0 through Gate 3.

---

## Full Flow Test (Gate A0 → Gate 1 → Gate 2 → Gate 3)

### Step 1 — Gate A0: Archetype Classification

**Prompt:**
```
@techlead classifique o arquétipo: uma automação Python que lê dados de um arquivo CSV exportado pelo ERP, cruza com dados da API de clientes, e envia um relatório por email toda segunda-feira às 8h.
```

**Expected:** `automation_script`, `standards/golden-model-python-automation.md`
**Must NOT:** `web_app`, Next.js, Prisma, Vercel

---

### Step 2 — Gate 1: PRD

**Prompt:**
```
@po escreva o PRD para esta automação: lê CSV do ERP, cruza com API de clientes, envia relatório por email toda segunda.
```

**Expected:**
- User story: "Como analista, quero receber o relatório toda segunda às 8h..."
- Non-functional: idempotência (se rodar 2x, não duplica email), dry-run mode
- Out of scope: UI, dashboard web

**Must NOT:** Architecture choices in the PRD (no Next.js mentions)

---

### Step 3 — Gate 2: Architecture

**Prompt:**
```
@architect proponha a arquitetura desta automação Python (Gate A0: automation_script). PRD disponível.
```

**Expected:**
- Python 3.12+, uv, Typer CLI, Pydantic v2
- structlog for structured JSON logging
- tenacity for API retry (exponential backoff, max 3 retries)
- `--dry-run` flag (lists what would be sent without sending)
- Secrets via env vars (not hardcoded)
- Idempotent: checks if report already sent for this week
- pytest + pytest-cov

**Must NOT:** Next.js, React, Vercel, Docker (unless justified), database (unless needed)

---

### Step 4 — Gate 3: Execution Plan

**Prompt:**
```
@engineer decomponha esta automação em tarefas atomizadas. Stack: Python + Typer + Pydantic v2 + tenacity + structlog.
```

**Expected:**
- Tasks ≤ 4h each
- Each task independently testable
- Order: CSV parser → API client → cross-reference logic → email sender → Typer CLI wiring → tests → dry-run validation
- Test plan per task

**Must NOT:** Tasks > 4h, vague tasks like "implement everything"

---

## Critical Invariants for This Flow

1. **AT NO POINT** should any agent recommend Next.js, Prisma, Vercel, or React for this project
2. **dry-run** must appear in Architecture (Gate 2) and Execution Plan (Gate 3)
3. **idempotência** must appear in PRD (Gate 1) and Architecture (Gate 2)
4. **ADR is NOT required** for choosing automation_script over web_app — that's correct archetype selection

---

## Regression Check

This flow is the primary regression test for archetype classification. If @techlead ever recommends a web_app stack for an automation task, it indicates:
1. The agent file at `~/.claude/agents/techlead.md` is stale — run `.\install.ps1`
2. The project classification knowledge is not loaded — check MCP with `.\test-mcp.ps1`
