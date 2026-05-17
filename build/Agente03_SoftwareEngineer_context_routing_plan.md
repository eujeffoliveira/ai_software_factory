# Agente03 — Context Routing Plan
## Build Date: 2026-05-17
## Edition: generic-white-label

This document records what was extracted from each build-time source and which Agente03 artifacts it was routed into.

---

## Source 1: `context/integrantes.md`

**What was extracted:**
- Agente03 role definition: "Software Engineer / Task Planner"
- Responsibilities: transform architecture into atomic execution plan; protect coding agents from context overflow
- Anti-responsibilities: cannot write final code, cannot invent endpoints, cannot change scope or architecture, cannot create schema without Architect
- Definition of Ready: PRD approved, architecture approved, API contract exists, DB schema exists, technical constraints clear, ADRs documented
- Definition of Done: Execution_Plan.json created, all tasks atomic, dependencies mapped, files listed, acceptance criteria associated, test requirements, security requirements, handoff package produced
- Escalation triggers: 7 scenarios requiring Tech Lead involvement
- 7 authorized skills: listed and described
- Gate 3 (Execution Plan Review) definition
- Handoff chain: Agente02 → Agente03 → Agente04 + Agente05
- Human interaction policy: via Tech Lead only

**Routed into:**
- `prompt.md` — complete system prompt with all operating principles and workflow
- `agent_config.json` — capabilities, handoff chain, escalation policy
- `skills_manifest.md` — 7 skills with full descriptions
- `quality_gate.md` — Gate 3 definition with all status codes
- `handoff_schema.json` — handoff package contract
- `failure_modes.md` — 10 failure modes derived from anti-responsibilities

---

## Source 2: `context/reference_architecture_generico.md`

**What was extracted:**
- Golden Path mandatory tech stack: Next.js 16, React 19, TypeScript 5, Tailwind v4, NextAuth v5, PostgreSQL/Supabase, Prisma 7/PrismaPg
- Migration rule: `prisma migrate deploy` (never `prisma db push`)
- Cron pattern: Vercel Cron + `guardCron()` as first call
- Validation rule: Zod at all system boundaries
- Test stack: Vitest (unit/integration) + Playwright (E2E)
- Data fetching order: Server Components > Server Actions > SWR
- Environment variables: always via `lib/env.ts`
- Logging: `audit_log` (human actions) + `sync_log` (jobs), structured JSON
- ADR requirement for Golden Path deviations

**Routed into:**
- `context_view.md` — Golden Path stack reference table (Section 8)
- `agent_config.json` — tech_stack_governance.golden_path object
- `knowledge/decision_rules.md` — DR007, DR008, DR012, DR013, DR014
- `knowledge/knowledge_cards.md` — Card007 (Server Action vs Route Handler), Card008 (migration rule), Card009 (guardCron), Card010 (Zod at boundaries)
- All skill `checklist.md` files — Golden Path constraints per skill
- `checklists/security_requirements_checklist.md` — security rules from Golden Path
- `checklists/test_requirements_checklist.md` — test tool mandates
- All templates — Golden Path reminders in Task_Handoff_Package.md

---

## Source 3: `context/manual_arquitetura_componentes_generico.md`

**What was extracted:**
- Execution plan format: plan_id, version, tasks[], critical_path, parallel_tracks
- Task object contract: all required fields and their types
- Handoff package structure: artifact_produced, summary, assumptions, risks, gate_status
- Gate 3 entry/exit criteria
- Artifact requirements for each gate

**Routed into:**
- `context_view.md` — Execution_Plan.json structure (Section 4), Task object schema (Section 5), Gate 3 artifacts (Section 9)
- `schemas/execution_plan.schema.json` — JSON Schema from artifact format
- `schemas/task.schema.json` — JSON Schema from task contract
- `handoff_schema.json` — handoff package JSON Schema
- `quality_gate.md` — Gate 3 entry criteria, mandatory artifacts table, blocking conditions
- `templates/Execution_Plan.json` — template based on format spec

---

## Source 4: `context/base_teorica.md`

**What was extracted:**
- Agente03 knowledge base: 5 reference books with role in agent's knowledge
- The Pragmatic Programmer — DRY, orthogonality, context management
- Code Complete — construction planning, requirements traceability, estimation
- Design Patterns (GoF) — pattern infrastructure separation, construction order
- Enterprise Integration Patterns — message contracts, integration point risk
- System Design Interview — critical path analysis, parallelism, delivery estimation

**Routed into:**
- `rag_manifest.json` — 6 collections with key concepts and distilled_into paths
- `knowledge/source_map.json` — source-to-artifact mapping for all 7 sources

---

## Source 5: Bibliography — 5 Books (lib/SoftwareEngineer/)

**What was distilled:**

| Book | Concepts → Artifacts |
|------|---------------------|
| The Pragmatic Programmer | P1, P2, P7 (principles) + H1, H7, H9 (heuristics) + Card001, Card003 (knowledge cards) + DR011 (decision rules) |
| Code Complete | P2, P4 (principles) + H2, H6, H8 (heuristics) + Card003, Card006 (knowledge cards) |
| Design Patterns (GoF) | P5 (principle) + H3 (heuristic) + Card002 (knowledge card) |
| Enterprise Integration Patterns | P3 (principle) + H4 (heuristic) + Card007 (knowledge card) |
| System Design Interview | P8 (principle) + H5, H10 (heuristics) + Card004, Card005 (knowledge cards) |

**Routed into:**
- `knowledge/principles.md` — P1–P8
- `knowledge/heuristics.md` — H1–H10
- `knowledge/knowledge_cards.md` — Card001–Card010
- `knowledge/source_map.json` — full traceability mapping
