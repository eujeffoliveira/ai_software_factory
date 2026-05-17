# Agent Briefing — Agente02_SoftwareArchitect

**Phase:** Architecture
**Gate Target:** Gate 2
**Project:** Enterprise Portal — Supplier Management Module
**Date:** 2026-05-12
**Issued by:** Agente00_TechLead

---

## Task

Design the system architecture for the Supplier Management Module, including the component diagram, API contract, and database schema. The architecture must adhere to the Golden Model (Next.js 16 + App Router + proxy.ts + Prisma 7 + Vercel + NextAuth v5). Produce `Architecture.md`, `API_Contract.json`, and `Prisma_Schema_Proposal.prisma`.

---

## Inputs Available

- [x] `PRD.md` — provided (approved at Gate 1)
- [x] `Open_Questions.md` — provided (2 open questions)
- [x] Golden Model — available in local context_view.md
- [ ] Existing codebase — not applicable (greenfield project)

---

## Expected Outputs

- `Architecture.md` — system components, data flow, architectural decisions
- `API_Contract.json` — all endpoints with methods, schemas, and auth requirements
- `Prisma_Schema_Proposal.prisma` — database schema with Prisma conventions
- `ADR-*.md` — if any Golden Path deviation is needed
- Handoff Package (mandatory)

---

## Constraints

- Must use Next.js 16 App Router — no pages/ router
- Must use proxy.ts — not middleware.ts
- Must use Prisma 7 with PrismaPg adapter and prisma migrate (not prisma db push in staging/production)
- Must use Vercel for deploy — no Docker, no Railway
- Must use NextAuth v5 with Google OAuth — no alternative auth providers
- Any deviation requires an ADR before proceeding
- Prisma model names: camelCase. DB column names: snake_case via @map()

---

## Open Questions to Address

- [ ] OQ-001: Should supplier deactivation trigger email notification to linked buyers? (non-blocking — design for optional email notification flag)
- [ ] OQ-002: What is the maximum allowed file size for supplier document uploads?

---

## Risks to Consider

- **Bulk import of suppliers from CSV** (MEDIUM) — design the import endpoint to use a background job (Vercel Cron or Server Action with streaming), not a synchronous request
- **Supplier data classification** — classify supplier PII fields before modeling to ensure audit_log compliance

---

## Golden Model Reminders

- Route handlers (`route.ts`) must be thin shells — no business logic
- Business logic lives in `lib/`, `features/`, or `actions/`
- All env vars must go through `lib/env.ts`
- `audit_log` required for: supplier approval/rejection, role changes, document access
- `sync_log` required for: any automated import or sync jobs
- Jobs must be idempotent — design bulk import with upsert pattern

---

## ADRs in Scope

- None yet — create ADR if any deviation from the above constraints is needed

---

## Escalation Policy

If during architecture you encounter:
- A requirement that cannot be met with the Golden Model → stop and alert Tech Lead with specific conflict
- A security decision that affects PII handling → stop and alert Tech Lead immediately
- A scope question that the PRD does not address → stop and alert Tech Lead (do not assume)
