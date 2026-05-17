# Agente06_QaEngineer — Generated Files Index

**Build date:** 2026-05-17  
**Total files:** 96  

---

## Core Files (8)

| File | Purpose |
|------|---------|
| `Agente06_QaEngineer/prompt.md` | System prompt — identity, 10 operating principles, workflow, handoff format |
| `Agente06_QaEngineer/agent_config.json` | Runtime config — allowed/blocked sources, capabilities, Golden Path, gate ownership |
| `Agente06_QaEngineer/context_view.md` | Compiled local context — Vitest patterns, Playwright patterns, test pyramid, decision matrix |
| `Agente06_QaEngineer/rag_manifest.json` | RAG policy — 6 collections, blocked raw sources |
| `Agente06_QaEngineer/skills_manifest.md` | Index of 9 skills with trigger conditions and interaction diagram |
| `Agente06_QaEngineer/quality_gate.md` | Gate 4 specification — entry/exit criteria, status codes, blocking conditions, inviolability |
| `Agente06_QaEngineer/handoff_schema.json` | JSON Schema for QA Handoff Package |
| `Agente06_QaEngineer/failure_modes.md` | 10 failure modes with symptoms, causes, corrective actions |

---

## Knowledge Files (5)

| File | Content |
|------|---------|
| `Agente06_QaEngineer/knowledge/principles.md` | P1–P12: 12 operating principles distilled from bibliography |
| `Agente06_QaEngineer/knowledge/heuristics.md` | H1–H15: 15 decision heuristics for rapid QA decisions |
| `Agente06_QaEngineer/knowledge/decision_rules.md` | DR001–DR017: 17 binding if-then rules governing gate decisions |
| `Agente06_QaEngineer/knowledge/knowledge_cards.md` | Card 001–Card 012: 12 reusable concept cards |
| `Agente06_QaEngineer/knowledge/source_map.json` | Maps 9 build-time sources to distilled artifacts |

---

## Schemas (6)

| File | Schema For |
|------|-----------|
| `Agente06_QaEngineer/schemas/qa_report.schema.json` | QA Report metadata block |
| `Agente06_QaEngineer/schemas/bug_report.schema.json` | Bug report structure |
| `Agente06_QaEngineer/schemas/test_result.schema.json` | Individual test result |
| `Agente06_QaEngineer/schemas/regression_report.schema.json` | Regression analysis report |
| `Agente06_QaEngineer/schemas/acceptance_validation.schema.json` | Acceptance criteria validation report |
| `Agente06_QaEngineer/schemas/api_contract_validation.schema.json` | API contract validation results |

---

## Templates (6)

| File | Template For |
|------|-------------|
| `Agente06_QaEngineer/templates/QA_Report.md` | Gate 4 decision artifact with 8 mandatory sections |
| `Agente06_QaEngineer/templates/Bug_Report.md` | Bug report with severity, reproduction steps, recommendation |
| `Agente06_QaEngineer/templates/Regression_Report.md` | Regression analysis for resubmissions |
| `Agente06_QaEngineer/templates/Vitest_Test_Template.ts` | Complete working Vitest test with 4 cases + proper mocks |
| `Agente06_QaEngineer/templates/Playwright_Test_Template.ts` | Complete working Playwright test with accessible selectors |
| `Agente06_QaEngineer/templates/Acceptance_Validation_Report.md` | AC-NNN to test mapping table |

---

## Checklists (7)

| File | Checklist For |
|------|--------------|
| `Agente06_QaEngineer/checklists/qa_quality_checklist.md` | Full Gate 4 evaluation sign-off |
| `Agente06_QaEngineer/checklists/acceptance_criteria_checklist.md` | AC-NNN mapping and testability check |
| `Agente06_QaEngineer/checklists/api_contract_validation_checklist.md` | Per-endpoint API contract checks |
| `Agente06_QaEngineer/checklists/accessibility_regression_checklist.md` | WCAG 2.1 AA per-flow checks |
| `Agente06_QaEngineer/checklists/test_coverage_checklist.md` | Coverage threshold verification |
| `Agente06_QaEngineer/checklists/failure_severity_checklist.md` | CRITICAL/HIGH/MEDIUM/LOW classification decision tree |
| `Agente06_QaEngineer/checklists/runtime_isolation_checklist.md` | Build-time vs. runtime isolation verification |

---

## Examples (6)

| File | Example Of |
|------|-----------|
| `Agente06_QaEngineer/examples/good_qa_report.md` | Complete APPROVED QA Report with evidence |
| `Agente06_QaEngineer/examples/bad_qa_report.md` | Incomplete report with annotated anti-patterns |
| `Agente06_QaEngineer/examples/good_bug_report.md` | CRITICAL bug report with full reproduction steps |
| `Agente06_QaEngineer/examples/bad_bug_report.md` | Vague bug report with annotated violations |
| `Agente06_QaEngineer/examples/good_test_case.ts` | Well-structured Vitest test with 4 cases |
| `Agente06_QaEngineer/examples/bad_test_case.ts` | Poor test with annotated anti-patterns |

---

## Skills (9 skills × 6 files = 54 files)

### 1. qa-review-skill (6 files)
- `skills/qa-review-skill/skill.md`
- `skills/qa-review-skill/input.schema.json`
- `skills/qa-review-skill/output.schema.json`
- `skills/qa-review-skill/checklist.md`
- `skills/qa-review-skill/examples/good_output.md`
- `skills/qa-review-skill/examples/bad_output.md`

### 2. vitest-generation-skill (6 files)
- `skills/vitest-generation-skill/skill.md`
- `skills/vitest-generation-skill/input.schema.json`
- `skills/vitest-generation-skill/output.schema.json`
- `skills/vitest-generation-skill/checklist.md`
- `skills/vitest-generation-skill/examples/good_output.md`
- `skills/vitest-generation-skill/examples/bad_output.md`

### 3. playwright-e2e-skill (6 files)
- `skills/playwright-e2e-skill/skill.md`
- `skills/playwright-e2e-skill/input.schema.json`
- `skills/playwright-e2e-skill/output.schema.json`
- `skills/playwright-e2e-skill/checklist.md`
- `skills/playwright-e2e-skill/examples/good_output.md`
- `skills/playwright-e2e-skill/examples/bad_output.md`

### 4. acceptance-criteria-validation-skill (6 files)
- `skills/acceptance-criteria-validation-skill/skill.md`
- `skills/acceptance-criteria-validation-skill/input.schema.json`
- `skills/acceptance-criteria-validation-skill/output.schema.json`
- `skills/acceptance-criteria-validation-skill/checklist.md`
- `skills/acceptance-criteria-validation-skill/examples/good_output.md`
- `skills/acceptance-criteria-validation-skill/examples/bad_output.md`

### 5. regression-analysis-skill (6 files)
- `skills/regression-analysis-skill/skill.md`
- `skills/regression-analysis-skill/input.schema.json`
- `skills/regression-analysis-skill/output.schema.json`
- `skills/regression-analysis-skill/checklist.md`
- `skills/regression-analysis-skill/examples/good_output.md`
- `skills/regression-analysis-skill/examples/bad_output.md`

### 6. api-contract-test-skill (6 files)
- `skills/api-contract-test-skill/skill.md`
- `skills/api-contract-test-skill/input.schema.json`
- `skills/api-contract-test-skill/output.schema.json`
- `skills/api-contract-test-skill/checklist.md`
- `skills/api-contract-test-skill/examples/good_output.md`
- `skills/api-contract-test-skill/examples/bad_output.md`

### 7. qa-reporting-skill (6 files)
- `skills/qa-reporting-skill/skill.md`
- `skills/qa-reporting-skill/input.schema.json`
- `skills/qa-reporting-skill/output.schema.json`
- `skills/qa-reporting-skill/checklist.md`
- `skills/qa-reporting-skill/examples/good_output.md`
- `skills/qa-reporting-skill/examples/bad_output.md`

### 8. accessibility-regression-skill (6 files)
- `skills/accessibility-regression-skill/skill.md`
- `skills/accessibility-regression-skill/input.schema.json`
- `skills/accessibility-regression-skill/output.schema.json`
- `skills/accessibility-regression-skill/checklist.md`
- `skills/accessibility-regression-skill/examples/good_output.md`
- `skills/accessibility-regression-skill/examples/bad_output.md`

### 9. test-failure-classification-skill (6 files)
- `skills/test-failure-classification-skill/skill.md`
- `skills/test-failure-classification-skill/input.schema.json`
- `skills/test-failure-classification-skill/output.schema.json`
- `skills/test-failure-classification-skill/checklist.md`
- `skills/test-failure-classification-skill/examples/good_output.md`
- `skills/test-failure-classification-skill/examples/bad_output.md`

---

## Build Reports (4)

| File | Content |
|------|---------|
| `build/Agente06_QaEngineer_build_report.md` | Build summary, design decisions, validation |
| `build/Agente06_QaEngineer_generated_files_index.md` | This file |
| `build/Agente06_QaEngineer_runtime_readiness_checklist.md` | Pre-runtime readiness verification |
| `build/Agente06_QaEngineer_knowledge_distillation_patch_report.md` | Bibliography distillation record |
