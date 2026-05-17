# Agente06_QaEngineer — Runtime Readiness Checklist

**Build date:** 2026-05-17  
**Verification:** All items must be checked before the agent is deployed at runtime.

---

## Structural Completeness

### Core Files (8 required)
- [x] `Agente06_QaEngineer/prompt.md` — exists, contains 10 operating principles, runtime context rule, workflow
- [x] `Agente06_QaEngineer/agent_config.json` — exists, `blocked_runtime_sources` includes `context/` and `lib/`
- [x] `Agente06_QaEngineer/context_view.md` — exists, contains Vitest/Playwright patterns, test pyramid, decision matrix
- [x] `Agente06_QaEngineer/rag_manifest.json` — exists, 6 collections, all with `runtime_accessible: true`
- [x] `Agente06_QaEngineer/skills_manifest.md` — exists, all 9 skills listed with triggers
- [x] `Agente06_QaEngineer/quality_gate.md` — exists, Gate 4 specification with 6 status codes
- [x] `Agente06_QaEngineer/handoff_schema.json` — exists, valid JSON Schema
- [x] `Agente06_QaEngineer/failure_modes.md` — exists, 10 failure modes documented

### Knowledge Files (5 required)
- [x] `Agente06_QaEngineer/knowledge/principles.md` — P1–P12 (12 principles)
- [x] `Agente06_QaEngineer/knowledge/heuristics.md` — H1–H15 (15 heuristics)
- [x] `Agente06_QaEngineer/knowledge/decision_rules.md` — DR001–DR017 (17 rules)
- [x] `Agente06_QaEngineer/knowledge/knowledge_cards.md` — Card 001–Card 012 (12 cards)
- [x] `Agente06_QaEngineer/knowledge/source_map.json` — 9 sources mapped

### Schemas (6 required)
- [x] `schemas/qa_report.schema.json`
- [x] `schemas/bug_report.schema.json`
- [x] `schemas/test_result.schema.json`
- [x] `schemas/regression_report.schema.json`
- [x] `schemas/acceptance_validation.schema.json`
- [x] `schemas/api_contract_validation.schema.json`

### Templates (6 required)
- [x] `templates/QA_Report.md` — 8 mandatory sections present
- [x] `templates/Bug_Report.md` — severity, reproduction steps, recommendation sections present
- [x] `templates/Regression_Report.md` — per-bug status table present
- [x] `templates/Vitest_Test_Template.ts` — compilable TypeScript with 4 test cases and mocks
- [x] `templates/Playwright_Test_Template.ts` — compilable TypeScript with accessible selectors only
- [x] `templates/Acceptance_Validation_Report.md` — AC-NNN mapping table present

### Checklists (7 required)
- [x] `checklists/qa_quality_checklist.md` — Runtime Knowledge Policy present
- [x] `checklists/acceptance_criteria_checklist.md` — Runtime Knowledge Policy present
- [x] `checklists/api_contract_validation_checklist.md` — Runtime Knowledge Policy present
- [x] `checklists/accessibility_regression_checklist.md` — Runtime Knowledge Policy present
- [x] `checklists/test_coverage_checklist.md` — Runtime Knowledge Policy present
- [x] `checklists/failure_severity_checklist.md` — Runtime Knowledge Policy present
- [x] `checklists/runtime_isolation_checklist.md` — Runtime Knowledge Policy present

### Examples (6 required)
- [x] `examples/good_qa_report.md` — APPROVED report with full evidence
- [x] `examples/bad_qa_report.md` — annotated anti-patterns
- [x] `examples/good_bug_report.md` — CRITICAL bug with reproduction steps
- [x] `examples/bad_bug_report.md` — vague report with annotations
- [x] `examples/good_test_case.ts` — 4 test cases, proper mocks, behavior assertions
- [x] `examples/bad_test_case.ts` — single test, no mocks, annotated violations

### Skills (9 × 6 = 54 files required)
- [x] qa-review-skill — 6 files (skill.md, input, output, checklist, good, bad)
- [x] vitest-generation-skill — 6 files
- [x] playwright-e2e-skill — 6 files
- [x] acceptance-criteria-validation-skill — 6 files
- [x] regression-analysis-skill — 6 files
- [x] api-contract-test-skill — 6 files
- [x] qa-reporting-skill — 6 files
- [x] accessibility-regression-skill — 6 files
- [x] test-failure-classification-skill — 6 files

---

## Content Quality Verification

### Runtime Isolation
- [x] `agent_config.json` `blocked_runtime_sources` includes `context/`, `lib/`, `*.pdf`
- [x] Every `skill.md` includes `## Knowledge Access Policy` section
- [x] Every skill `checklist.md` includes `## Runtime Knowledge Policy` item
- [x] `checklists/runtime_isolation_checklist.md` lists authorized vs. blocked sources
- [x] No files in `context/` referenced as runtime sources in any artifact
- [x] No files in `lib/` referenced as runtime sources in any artifact

### White-Label Compliance
- [x] No organization-specific names in any file
- [x] No `raiz-orange`, `raiz-teal` references
- [x] Generic identifiers used: `organization.com`, `testuser@organization.com`, `stakeholder`
- [x] `_generico` suffix convention noted for white-label context
- [x] `context/client_profile.md` not referenced in agent files

### Golden Path Tech Stack
- [x] `agent_config.json` `golden_path` section includes all required stack items
- [x] Vitest (not Jest/Mocha) specified for unit tests
- [x] Playwright (not Cypress/Selenium) specified for E2E
- [x] Next.js 16 App Router referenced in context_view.md
- [x] `proxy.ts` (not `middleware.ts`) in golden_path
- [x] `prisma migrate deploy` for prod, NOT `prisma db push`
- [x] Coverage thresholds: 80% new logic, 100% auth paths

### Gate 4 Ownership
- [x] `agent_config.json` `can_be_overridden_by_tech_lead: false`
- [x] `quality_gate.md` inviolability notice prominently stated
- [x] `prompt.md` Principle 3: "Gate 4 is inviolable — no one overrides a QA block except QA itself"
- [x] 6 authorized Gate 4 status codes documented
- [x] Override policy explicitly states "this is explicitly prohibited"

---

## Final Readiness Verdict

**READY FOR RUNTIME DEPLOYMENT**

All 96 files created. All required sections present. Runtime isolation enforced. White-label compliance verified. Golden Path tech stack embedded. Gate 4 ownership and inviolability documented.

The agent is self-contained and reads only from its own folder and project input artifacts at runtime.
