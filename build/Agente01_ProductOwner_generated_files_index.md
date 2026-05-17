# Agente01_ProductOwner — Generated Files Index

**Build Date:** 2026-05-17  
**Total Files:** 118

---

## Core Agent Files (8)

| File | Purpose |
|------|---------|
| `prompt.md` | Operational system prompt — role, principles, workflow, policies |
| `agent_config.json` | Runtime configuration — allowed/blocked sources, capabilities |
| `context_view.md` | Compiled local context — role, gates, standards, isolation policy |
| `rag_manifest.json` | RAG policy — collections, retrieval rules, blocked raw sources |
| `skills_manifest.md` | Index of all 10 skills with triggers and descriptions |
| `quality_gate.md` | Gate 1 PRD Approval criteria and readiness checklist |
| `handoff_schema.json` | JSON Schema for Handoff Package to Gate 1 |
| `failure_modes.md` | 14 failure modes with symptoms, causes, and recovery actions |

---

## Knowledge Directory (5)

| File | Purpose |
|------|---------|
| `knowledge/principles.md` | 10 operational principles (P1–P10) |
| `knowledge/heuristics.md` | 12 practical decision heuristics (H1–H12) |
| `knowledge/decision_rules.md` | 30+ actionable if-then rules (DR001–DR030) |
| `knowledge/knowledge_cards.md` | 10 reusable concept cards |
| `knowledge/source_map.json` | Build-time source → distilled artifact mapping |

---

## Schemas (9)

| File | Validates |
|------|-----------|
| `schemas/prd.schema.json` | Complete PRD document structure |
| `schemas/user_story.schema.json` | Individual user story with INVEST fields |
| `schemas/acceptance_criteria.schema.json` | BDD/Gherkin acceptance criterion |
| `schemas/interview_question.schema.json` | Requirements interview question |
| `schemas/open_question.schema.json` | Open question (OQ-NNN format) |
| `schemas/business_rule.schema.json` | Business rule (BR-NNN with source) |
| `schemas/non_functional_requirement.schema.json` | NFR with category and metric |
| `schemas/product_risk.schema.json` | Product risk (PRISK-NNN) |
| `schemas/scope_boundary.schema.json` | In-scope/out-of-scope definition |

---

## Templates (10)

| File | Produces |
|------|---------|
| `templates/PRD.md` | Complete PRD.md with all 15 sections |
| `templates/Requirements_Interview_Log.md` | Structured interview log |
| `templates/Open_Questions.md` | OQ register with criticality tiers |
| `templates/User_Story_Map.md` | Story map by persona and activity |
| `templates/Acceptance_Criteria.md` | Gherkin criteria per user story |
| `templates/Business_Rules.md` | BR register with source traceability |
| `templates/Non_Functional_Requirements.md` | NFRs across all 10 categories |
| `templates/Scope_Boundary.md` | In-scope / out-of-scope with rationale |
| `templates/Product_Risks.md` | PRISK register with mitigations |
| `templates/Handoff_To_Architect.md` | Gate 1 Handoff Package |

---

## Checklists (10)

| File | Purpose |
|------|---------|
| `checklists/prd_quality_checklist.md` | 30+ point PRD quality verification |
| `checklists/invest_checklist.md` | INVEST compliance per user story |
| `checklists/bdd_acceptance_checklist.md` | BDD/Gherkin format and coverage |
| `checklists/scope_boundary_checklist.md` | Scope definition completeness |
| `checklists/non_functional_requirements_checklist.md` | NFR coverage across 10 categories |
| `checklists/open_questions_checklist.md` | OQ classification and escalation |
| `checklists/business_rules_checklist.md` | Business rule traceability |
| `checklists/data_requirements_checklist.md` | Data entities and privacy flags |
| `checklists/gate_1_prd_approval_checklist.md` | 42-item Gate 1 readiness check |
| `checklists/runtime_isolation_checklist.md` | Runtime source isolation verification |

---

## Examples (10)

| File | Shows |
|------|-------|
| `examples/good_prd.md` | Complete PRD for appointment management system |
| `examples/bad_prd.md` | PRD with 6 annotated defects |
| `examples/good_user_story.md` | 3 INVEST-compliant stories with explanation |
| `examples/bad_user_story.md` | 3 stories with different violations annotated |
| `examples/good_acceptance_criteria.md` | Gherkin criteria with happy/edge/negative coverage |
| `examples/bad_acceptance_criteria.md` | Non-testable criteria with annotations |
| `examples/good_open_questions.md` | 4 well-formed OQs with varied criticality |
| `examples/bad_open_questions.md` | 4 malformed OQs with annotations |
| `examples/good_handoff_to_architect.md` | Complete Gate 1 Handoff Package |
| `examples/bad_handoff_to_architect.md` | Incomplete handoff with 5 annotated problems |

---

## Skills (10 skills × 6 files = 60 files)

| Skill | Files |
|-------|-------|
| `requirements-interview-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `prd-generation-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `user-story-mapping-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `bdd-acceptance-criteria-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `scope-boundary-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `requirements-quality-review-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `non-functional-requirements-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `open-questions-management-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `business-rules-extraction-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `product-risk-analysis-skill/` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |

---

## Build Reports (6)

| File | Purpose |
|------|---------|
| `build/Agente01_ProductOwner_scan_report.md` | Pre-build environment scan |
| `build/Agente01_ProductOwner_context_routing_plan.md` | What was extracted from which source |
| `build/Agente01_ProductOwner_bibliography_inventory.json` | Books processed and artifacts derived |
| `build/Agente01_ProductOwner_build_report.md` | Full build summary |
| `build/Agente01_ProductOwner_generated_files_index.md` | This file |
| `build/Agente01_ProductOwner_runtime_readiness_checklist.md` | Static validation — all checks PASS |

---

## Gaps / Lacunas

| Item | Status | Impact |
|------|--------|--------|
| `context/integrantes_generico.md` | Not found — used `integrantes.md` with abstraction | LOW |
| `User Story Mapping – Jeff Patton` | Not in lib/ — covered by Cohn | LOW |
| `Specification by Example – Adzic` | Not in lib/ — BDD covered via training knowledge | LOW |
| `Impact Mapping – Adzic` | Not in lib/ — incorporated into risk analysis skill | LOW |
