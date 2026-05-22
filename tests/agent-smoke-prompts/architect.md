# Smoke Test — @architect

## Purpose

Verify the Software Architect agent follows the Golden Model for the identified archetype, produces complete architecture artifacts, triggers ADRs correctly, and structures security/observability strategy.

---

## Smoke Test 1 — Golden Model Compliance (web_app)

**Prompt:**
```
@architect proponha a arquitetura para um portal de gestão de fornecedores. O projeto é web_app (Next.js 16 stack). Produza Architecture.md.
```

**Expected behavior:**
- Uses Next.js 16 (App Router), React 19, TypeScript 5, Tailwind v4
- Uses NextAuth v5 + Google OAuth
- Uses PostgreSQL via Supabase, Prisma 7 with PrismaPg adapter
- Deploy on Vercel + Vercel Cron
- Uses `proxy.ts` NOT `middleware.ts`
- Validation with Zod at all boundaries
- Tests: Vitest (unit) + Playwright (E2E)
- Structured JSON logs: `audit_log` (human actions), `sync_log` (jobs)

**Pass signals:** All stack items from Golden Model present
**Fail signals:** Django, MongoDB, middleware.ts, custom auth instead of NextAuth

---

## Smoke Test 2 — ADR Trigger for Deviation

**Prompt:**
```
@architect para o módulo de relatórios PDF, o cliente quer usar Puppeteer no servidor em vez de uma lib client-side. Como você documenta isso?
```

**Expected behavior:**
- Recognizes Puppeteer as a deviation from standard (Vercel serverless doesn't support it well)
- Requires ADR before proceeding
- Documents trade-offs: serverless timeout limits, memory constraints
- Proposes alternatives (wkhtmltopdf via separate worker, react-pdf client-side)

**Pass signals:** ADR created, deviation documented with rationale
**Fail signals:** Approves without ADR

---

## Smoke Test 3 — Security Strategy

**Prompt:**
```
@architect o sistema lida com dados financeiros de clientes. Defina a estratégia de segurança na arquitetura.
```

**Expected behavior:**
- Auth: NextAuth v5, role-based authorization
- Data encryption at rest (Supabase handles) and in transit (TLS)
- Input validation: Zod at all boundaries
- LGPD compliance: data classification, retention policy, consent
- No secrets in code (env vars via `lib/env.ts`)
- Rate limiting on API routes
- Security headers

**Pass signals:** Auth + authorization + LGPD + encryption mentioned
**Fail signals:** No security section, or recommends custom auth

---

## Smoke Test 4 — automation_script Architecture

**Prompt:**
```
@architect proponha a arquitetura para uma automação Python que sincroniza dados de um CRM via API REST para um PostgreSQL local, rodando diariamente via cron.
```

**Expected behavior:**
- Python 3.12+ + uv + Typer + Pydantic v2
- structlog for structured logging
- tenacity for retry with exponential backoff
- pytest + coverage
- dry-run flag
- Secrets via environment variables (no hardcoded)
- Idempotency: upsert logic, not insert-only

**Pass signals:** Python stack correct, dry-run, retry, idempotency
**Fail signals:** Recommends Next.js, Docker containers without justification for simple scripts

---

## Notes

Architecture artifacts should be validated at Gate 2. Run `.\doctor.ps1` if agent is unresponsive or inconsistent.
