# Agente04_DevBackend — Runtime Readiness Checklist

**Build Date:** 2026-05-17  
**Verified By:** Build Phase

---

## Core Files

- [x] `prompt.md` — present, complete with all 10 operating principles
- [x] `agent_config.json` — valid JSON, mode: runtime-local-only
- [x] `context_view.md` — 12 sections, no references to context/ or lib/
- [x] `rag_manifest.json` — 6 collections, runtime_local_only: true
- [x] `skills_manifest.md` — all 11 skills documented
- [x] `quality_gate.md` — Gate 4 complete with entry criteria, checklist, status codes
- [x] `handoff_schema.json` — valid JSON Schema, required_next_agent: const "Agente06_QaEngineer"
- [x] `failure_modes.md` — 12 failure modes with symptoms and corrective actions

## Knowledge Files

- [x] `knowledge/principles.md` — P1–P10, all sourced and distilled
- [x] `knowledge/heuristics.md` — H1–H12, all actionable
- [x] `knowledge/decision_rules.md` — DR001–DR014, if-then format
- [x] `knowledge/knowledge_cards.md` — Card 001–010, self-contained
- [x] `knowledge/source_map.json` — sources mapped to artifacts, runtime_access_policy correct

## Schemas

- [x] `schemas/backend_task.schema.json` — valid draft-2020-12
- [x] `schemas/backend_implementation_report.schema.json` — valid draft-2020-12
- [x] `schemas/server_action.schema.json` — valid, file_path pattern enforces location
- [x] `schemas/route_handler.schema.json` — valid, max_lines constraint present
- [x] `schemas/dal_function.schema.json` — valid, uses_raw_sql: const false
- [x] `schemas/cron_job.schema.json` — valid, guard_cron_first: const true, sync_log_required: const true
- [x] `schemas/integration_client.schema.json` — valid, called_inside_transaction: const false

## Templates

- [x] `templates/Backend_Implementation_Report.md` — all required sections present
- [x] `templates/Server_Action_Template.ts` — real TypeScript, all patterns correct
- [x] `templates/Route_Handler_Template.ts` — thin handler pattern, ≤30 lines
- [x] `templates/Cron_Route_Template.ts` — guardCron first, syncLog in finally
- [x] `templates/Prisma_DAL_Template.ts` — no raw SQL, typed, named const export
- [x] `templates/Zod_Schema_Template.ts` — module-level schemas, type inference
- [x] `templates/Integration_Client_Template.ts` — env.ts, Zod response validation, timeout
- [x] `templates/Backend_Test_Template.ts` — 4 required test cases, all mocks present

## Checklists

- [x] `checklists/backend_quality_checklist.md` — 35+ items, covers all quality dimensions
- [x] `checklists/authz_checklist.md` — auth + authorization checks
- [x] `checklists/zod_validation_checklist.md` — boundary validation
- [x] `checklists/sql_safety_checklist.md` — injection prevention
- [x] `checklists/audit_log_checklist.md` — audit trail compliance
- [x] `checklists/sync_log_checklist.md` — operational monitoring
- [x] `checklists/cron_idempotency_checklist.md` — retry safety
- [x] `checklists/backend_test_checklist.md` — test coverage
- [x] `checklists/runtime_isolation_checklist.md` — build/runtime isolation

## Examples

- [x] `examples/good_server_action.ts` — correct, annotated
- [x] `examples/bad_server_action.ts` — 7 violations, each annotated with WHY
- [x] `examples/good_route_handler.ts` — thin, correct, ≤28 lines
- [x] `examples/bad_route_handler.ts` — 4 violations, each annotated
- [x] `examples/good_prisma_dal.ts` — typed, no raw SQL, upsert present
- [x] `examples/bad_prisma_dal.ts` — 4 violations, each annotated
- [x] `examples/good_backend_report.md` — all sections, gate_ready: true
- [x] `examples/bad_backend_report.md` — incomplete, gate_ready: true incorrectly set, annotated

## Skills (11 skills × 6 files)

All 11 skills verified:

| Skill | skill.md | input.schema | output.schema | checklist.md | good_output | bad_output |
|-------|----------|-------------|---------------|-------------|-------------|------------|
| nextjs-server-action-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| nextjs-route-handler-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| prisma-dal-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| zod-validation-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| cron-job-implementation-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| structured-logging-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| audit-log-implementation-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| sync-log-implementation-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| backend-test-generation-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| external-integration-client-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| sql-safety-review-skill | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

## Runtime Isolation Verification

- [x] `agent_config.json` blocks context/, lib/, *.pdf
- [x] context_view.md contains no references to blocked sources
- [x] rag_manifest.json runtime_local_only: true, raw_books_at_runtime: false
- [x] All 11 skills have `## Knowledge Access Policy` in skill.md
- [x] All 11 skills have `## Runtime Knowledge Policy` in checklist.md
- [x] knowledge/source_map.json marks raw_sources_allowed: false
- [x] No org-specific names in any generic artifact
- [x] All JSON is valid (no JavaScript comments)

---

## Overall Status

**✅ READY FOR RUNTIME**

All checks passed. Agente04_DevBackend can be deployed to production pipelines.
