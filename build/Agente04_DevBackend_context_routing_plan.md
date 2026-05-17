# Agente04_DevBackend — Context Routing Plan

**Build Date:** 2026-05-17  
**Purpose:** Documents what was extracted from each build-time source and routed to which Agente04 artifact.

---

## Source: context/integrantes.md

| Extracted Element | Routed To |
|-------------------|-----------|
| Agent role: Dev Backend — implements server-side logic | `prompt.md §Role`, `agent_config.json §description` |
| Handoff chain: Engineer → DevBackend → QA | `agent_config.json §handoff`, `prompt.md §Inputs/Outputs` |
| 11 authorized skill names | `skills_manifest.md`, `prompt.md §Authorized Skills` |
| Definition of Ready (7 items) | `agent_config.json §definition_of_ready`, `quality_gate.md §Entry Criteria` |
| Definition of Done (11 items) | `agent_config.json §definition_of_done`, `quality_gate.md §What to Prepare` |
| Anti-responsibilities (11 items) | `agent_config.json §anti_responsibilities`, `failure_modes.md` |
| Escalation triggers (8 items) | `agent_config.json §escalation_triggers`, `quality_gate.md §When to Escalate` |
| Gate 4 participation (submitter) | `quality_gate.md`, `agent_config.json §quality_gate` |
| Status codes: RETURNED_FOR_REVISION, BLOCKED_MISSING_TESTS, BLOCKED_SECURITY_VIOLATION | `quality_gate.md §Status Codes` |

---

## Source: context/reference_architecture_generico.md

| Extracted Element | Routed To |
|-------------------|-----------|
| Golden Path tech stack (full) | `agent_config.json §golden_path`, `context_view.md` |
| Next.js 16 App Router patterns | `context_view.md §2-5`, `templates/`, `examples/` |
| Server Action file location: `features/*/actions/*.ts` | `context_view.md §3`, `schemas/server_action.schema.json` |
| Route Handler location: `app/api/*/route.ts`, max 30 lines | `context_view.md §4`, `schemas/route_handler.schema.json` |
| guardCron() must be first call in cron routes | `context_view.md §5`, `knowledge/decision_rules.md DR004`, `checklists/cron_idempotency_checklist.md` |
| Prisma DAL location: `lib/db/[model].dal.ts` | `context_view.md §6`, `schemas/dal_function.schema.json` |
| auth check first policy | `context_view.md §9`, `knowledge/principles.md P3`, `knowledge/decision_rules.md DR011` |
| IDOR prevention: resource.userId check | `context_view.md §9`, `knowledge/principles.md P4`, `knowledge/decision_rules.md DR012` |
| audit_log fields and policy | `context_view.md §8`, `knowledge/knowledge_cards.md Card 005`, `checklists/audit_log_checklist.md` |
| sync_log fields and policy | `context_view.md §8`, `knowledge/knowledge_cards.md Card 005`, `checklists/sync_log_checklist.md` |
| Migration policy: migrate deploy never db push | `context_view.md §10`, `failure_modes.md FM-06` |
| lib/env.ts for all env vars | `context_view.md §7`, `knowledge/decision_rules.md DR006` |
| Zod at all system boundaries | `context_view.md §7`, `knowledge/principles.md P2` |

---

## Source: context/manual_arquitetura_componentes_generico.md

| Extracted Element | Routed To |
|-------------------|-----------|
| Handoff Package structure | `handoff_schema.json` |
| Backend_Implementation_Report.md structure | `schemas/backend_implementation_report.schema.json`, `templates/Backend_Implementation_Report.md` |
| Gate 4 entry criteria | `quality_gate.md §Entry Criteria` |
| Gate 4 self-review requirements | `quality_gate.md §Self-Review Checklist`, `checklists/backend_quality_checklist.md` |

---

## Source: lib/DevBackend/clean_code.pdf

| Extracted Concept | Routed To |
|-------------------|-----------|
| SRP applied to web handlers (thin route handlers) | `knowledge/principles.md P1` |
| Error handling: operators vs users | `knowledge/principles.md P8` |
| Configuration isolation (env vars) | `knowledge/principles.md P9` |
| Test-driven approach | `knowledge/principles.md P10` |
| Functions do one thing | `knowledge/heuristics.md H1`, `knowledge/knowledge_cards.md Card 010` |
| No magic numbers | `knowledge/knowledge_cards.md Card 010` |

---

## Source: lib/DevBackend/microservices_patterns.pdf

| Extracted Concept | Routed To |
|-------------------|-----------|
| Idempotent Consumer pattern | `knowledge/principles.md P7`, `knowledge/heuristics.md H4` |
| Transaction boundary design | `knowledge/decision_rules.md DR008`, `failure_modes.md FM-11` |
| Audit trail / transactional outbox | `knowledge/knowledge_cards.md Card 005` |
| Idempotency strategies (upsert, existence check, dedup) | `knowledge/knowledge_cards.md Card 009` |

---

## Source: lib/DevBackend/architecture_patterns_python.pdf

| Extracted Concept | Routed To |
|-------------------|-----------|
| Ports and Adapters — Zod as adapter | `knowledge/principles.md P2` |
| Repository Pattern — DAL | `knowledge/principles.md P5`, `knowledge/knowledge_cards.md Card 004` |
| Service Layer | `context_view.md §2 (project structure)` |
| TDD approach | `knowledge/principles.md P10`, `knowledge/decision_rules.md DR010` |

---

## Source: lib/DevBackend/programming_pearls.pdf

| Extracted Concept | Routed To |
|-------------------|-----------|
| Parameterized queries (no string building) | `knowledge/heuristics.md H6` |
| Thin handlers (avoid unnecessary computation) | `knowledge/heuristics.md H12` |

---

## Source: lib/DevBackend/introduction_to_algorithms.pdf

| Extracted Concept | Routed To |
|-------------------|-----------|
| Algorithmic approach to idempotency | `knowledge/knowledge_cards.md Card 009` |

---

## Source: lib/DevBackend/grokking_algorithms.pdf

| Extracted Concept | Routed To |
|-------------------|-----------|
| Big O and N+1 patterns | `knowledge/heuristics.md H11` |
