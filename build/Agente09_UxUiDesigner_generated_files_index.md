# Agente09_UxUiDesigner — Generated Files Index
## Build Date: 2026-05-17
## Total Files: 65

---

## Core Agent Files (8)

| File | Status | Description |
|------|--------|-------------|
| `Agente09_UxUiDesigner/prompt.md` | COMPLETE | Agent identity, 10 operating principles, workflow, escalation policy |
| `Agente09_UxUiDesigner/agent_config.json` | COMPLETE | Runtime config, blocked sources, capabilities, golden_path tokens |
| `Agente09_UxUiDesigner/context_view.md` | COMPLETE | Compiled runtime context: pipeline, conventions, tokens, WCAG, Recharts |
| `Agente09_UxUiDesigner/rag_manifest.json` | COMPLETE | RAG policy, 6 collections, blocked sources |
| `Agente09_UxUiDesigner/skills_manifest.md` | COMPLETE | Index of 5 skills with triggers and I/O |
| `Agente09_UxUiDesigner/quality_gate.md` | COMPLETE | Design Review pre-condition, 5 status codes, blocking conditions |
| `Agente09_UxUiDesigner/handoff_schema.json` | COMPLETE | JSON Schema for Design Package Handoff |
| `Agente09_UxUiDesigner/failure_modes.md` | COMPLETE | 8 failure modes with symptoms, causes, gate impact |

---

## Knowledge Files (5)

| File | Status | Items |
|------|--------|-------|
| `Agente09_UxUiDesigner/knowledge/principles.md` | COMPLETE | P1–P12 (12 principles) |
| `Agente09_UxUiDesigner/knowledge/heuristics.md` | COMPLETE | H1–H15 (15 heuristics) |
| `Agente09_UxUiDesigner/knowledge/decision_rules.md` | COMPLETE | DR001–DR015 (15 rules) |
| `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` | COMPLETE | Cards 001–012 (12 cards) |
| `Agente09_UxUiDesigner/knowledge/source_map.json` | COMPLETE | 5 build-time sources tracked |

---

## Schema Files (5)

| File | Status | Validates |
|------|--------|-----------|
| `Agente09_UxUiDesigner/schemas/ux_flow.schema.json` | COMPLETE | UX_Flow.md machine-readable validation |
| `Agente09_UxUiDesigner/schemas/wireframe.schema.json` | COMPLETE | Wireframes.md metadata |
| `Agente09_UxUiDesigner/schemas/ui_spec.schema.json` | COMPLETE | UI_Spec.md component summary |
| `Agente09_UxUiDesigner/schemas/usability_checklist.schema.json` | COMPLETE | Usability review completion record |
| `Agente09_UxUiDesigner/schemas/screen_state.schema.json` | COMPLETE | 4-state specification per component |

---

## Template Files (5)

| File | Status | Description |
|------|--------|-------------|
| `Agente09_UxUiDesigner/templates/UX_Flow.md` | COMPLETE | Full UX Flow template with all sections |
| `Agente09_UxUiDesigner/templates/Wireframes.md` | COMPLETE | Desktop + mobile wireframe template |
| `Agente09_UxUiDesigner/templates/UI_Spec.md` | COMPLETE | Full component spec template |
| `Agente09_UxUiDesigner/templates/Usability_Checklist.md` | COMPLETE | 8-section usability review template |
| `Agente09_UxUiDesigner/templates/Screen_States.md` | COMPLETE | 4-state specification template |

---

## Checklist Files (7)

| File | Status | Sections |
|------|--------|---------|
| `Agente09_UxUiDesigner/checklists/ux_flow_checklist.md` | COMPLETE | Pre/execution/error/edge/data/PRD/post |
| `Agente09_UxUiDesigner/checklists/wireframe_quality_checklist.md` | COMPLETE | Coverage/layout/states/inventory/mobile/final |
| `Agente09_UxUiDesigner/checklists/ui_spec_checklist.md` | COMPLETE | Props/loading/error/empty/populated/interactive/responsive/accessibility/global |
| `Agente09_UxUiDesigner/checklists/usability_checklist.md` | COMPLETE | 11 usability review sections |
| `Agente09_UxUiDesigner/checklists/design_system_application_checklist.md` | COMPLETE | Hex scan/org scan/token mapping/interactive/status/border/reuse/gap |
| `Agente09_UxUiDesigner/checklists/accessibility_basics_checklist.md` | COMPLETE | WCAG AA: contrast/color/images/forms/keyboard/screen-reader/focus/responsive |
| `Agente09_UxUiDesigner/checklists/runtime_isolation_checklist.md` | COMPLETE | Allowed sources / blocked sources / escalation path |

---

## Example Files (6)

| File | Status | Description |
|------|--------|-------------|
| `Agente09_UxUiDesigner/examples/good_ux_flow.md` | COMPLETE | Complete flow: 5 steps, 4 error paths, 5 edge cases, 2 decision points |
| `Agente09_UxUiDesigner/examples/bad_ux_flow.md` | COMPLETE | Annotated bad: happy-path-only, vague steps, no traceability |
| `Agente09_UxUiDesigner/examples/good_wireframe.md` | COMPLETE | Desktop + mobile, named components, states, index |
| `Agente09_UxUiDesigner/examples/bad_wireframe.md` | COMPLETE | Annotated bad: desktop-only, vague, color in wireframe |
| `Agente09_UxUiDesigner/examples/good_ui_spec.md` | COMPLETE | Full spec: interface, 3 empty state variants, tokens, accessibility |
| `Agente09_UxUiDesigner/examples/bad_ui_spec.md` | COMPLETE | Annotated bad: no interface, spinner, hardcoded hex, no accessibility |

---

## Skill Files (5 skills × 6 files = 30)

### ux-flow-design-skill (6 files)
| File | Status |
|------|--------|
| `skills/ux-flow-design-skill/skill.md` | COMPLETE |
| `skills/ux-flow-design-skill/input.schema.json` | COMPLETE |
| `skills/ux-flow-design-skill/output.schema.json` | COMPLETE |
| `skills/ux-flow-design-skill/checklist.md` | COMPLETE |
| `skills/ux-flow-design-skill/examples/good_output.md` | COMPLETE |
| `skills/ux-flow-design-skill/examples/bad_output.md` | COMPLETE |

### wireframe-spec-skill (6 files)
| File | Status |
|------|--------|
| `skills/wireframe-spec-skill/skill.md` | COMPLETE |
| `skills/wireframe-spec-skill/input.schema.json` | COMPLETE |
| `skills/wireframe-spec-skill/output.schema.json` | COMPLETE |
| `skills/wireframe-spec-skill/checklist.md` | COMPLETE |
| `skills/wireframe-spec-skill/examples/good_output.md` | COMPLETE |
| `skills/wireframe-spec-skill/examples/bad_output.md` | COMPLETE |

### ui-state-design-skill (6 files)
| File | Status |
|------|--------|
| `skills/ui-state-design-skill/skill.md` | COMPLETE |
| `skills/ui-state-design-skill/input.schema.json` | COMPLETE |
| `skills/ui-state-design-skill/output.schema.json` | COMPLETE |
| `skills/ui-state-design-skill/checklist.md` | COMPLETE |
| `skills/ui-state-design-skill/examples/good_output.md` | COMPLETE |
| `skills/ui-state-design-skill/examples/bad_output.md` | COMPLETE |

### usability-review-skill (6 files)
| File | Status |
|------|--------|
| `skills/usability-review-skill/skill.md` | COMPLETE |
| `skills/usability-review-skill/input.schema.json` | COMPLETE |
| `skills/usability-review-skill/output.schema.json` | COMPLETE |
| `skills/usability-review-skill/checklist.md` | COMPLETE |
| `skills/usability-review-skill/examples/good_output.md` | COMPLETE |
| `skills/usability-review-skill/examples/bad_output.md` | COMPLETE |

### design-system-application-skill (6 files)
| File | Status |
|------|--------|
| `skills/design-system-application-skill/skill.md` | COMPLETE |
| `skills/design-system-application-skill/input.schema.json` | COMPLETE |
| `skills/design-system-application-skill/output.schema.json` | COMPLETE |
| `skills/design-system-application-skill/checklist.md` | COMPLETE |
| `skills/design-system-application-skill/examples/good_output.md` | COMPLETE |
| `skills/design-system-application-skill/examples/bad_output.md` | COMPLETE |

---

## Build Report Files (4)

| File | Status |
|------|--------|
| `build/Agente09_UxUiDesigner_build_report.md` | COMPLETE |
| `build/Agente09_UxUiDesigner_generated_files_index.md` | COMPLETE (this file) |
| `build/Agente09_UxUiDesigner_runtime_readiness_checklist.md` | COMPLETE |
| `build/Agente09_UxUiDesigner_knowledge_distillation_patch_report.md` | COMPLETE |

---

## File Count Summary

| Category | Count |
|----------|-------|
| Core agent files | 8 |
| Knowledge files | 5 |
| Schema files | 5 |
| Template files | 5 |
| Checklist files | 7 |
| Example files | 6 |
| Skill files (5 × 6) | 30 |
| Build reports | 4 |
| **Total** | **70** |

_Note: 65 new files + 5 files that existed as stubs = 70 total in agent folder. The 5 pre-existing files (prompt.md, agent_config.json, context_view.md, skills_manifest.md, and the 2 schemas) were already complete and were not modified._
