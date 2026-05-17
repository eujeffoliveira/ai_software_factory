# Agente05_DevFrontend — Generated Files Index

**Build Date:** 2026-05-17
**Total Files:** 103

---

## Core Files (8)

| # | File | Description |
|---|------|-------------|
| 1 | `Agente05_DevFrontend/prompt.md` | Agent identity, mission, operating principles, workflow |
| 2 | `Agente05_DevFrontend/agent_config.json` | Runtime config, allowed/blocked sources, capabilities |
| 3 | `Agente05_DevFrontend/context_view.md` | Compiled frontend patterns (14 sections) |
| 4 | `Agente05_DevFrontend/rag_manifest.json` | RAG policy, collections, chunking, blocked sources |
| 5 | `Agente05_DevFrontend/skills_manifest.md` | Index of all 10 skills with detail |
| 6 | `Agente05_DevFrontend/quality_gate.md` | Gate 4 participation — entry criteria, status codes |
| 7 | `Agente05_DevFrontend/handoff_schema.json` | JSON Schema for handoff package to QA |
| 8 | `Agente05_DevFrontend/failure_modes.md` | 10 failure modes with symptoms and fixes |

---

## Knowledge Files (5)

| # | File | Content |
|---|------|---------|
| 9 | `Agente05_DevFrontend/knowledge/principles.md` | P1–P12 operating principles |
| 10 | `Agente05_DevFrontend/knowledge/heuristics.md` | H1–H15 decision heuristics |
| 11 | `Agente05_DevFrontend/knowledge/decision_rules.md` | DR001–DR020 if-then rules |
| 12 | `Agente05_DevFrontend/knowledge/knowledge_cards.md` | Card 001–012 concept cards |
| 13 | `Agente05_DevFrontend/knowledge/source_map.json` | Build-time source → artifact mapping |

---

## Schema Files (6)

| # | File | Validates |
|---|------|-----------|
| 14 | `Agente05_DevFrontend/schemas/frontend_task.schema.json` | Atomic frontend tasks from Execution_Plan.json |
| 15 | `Agente05_DevFrontend/schemas/component_spec.schema.json` | Component specifications |
| 16 | `Agente05_DevFrontend/schemas/frontend_implementation_report.schema.json` | Implementation report metadata |
| 17 | `Agente05_DevFrontend/schemas/ui_state.schema.json` | Loading/error/empty state specs |
| 18 | `Agente05_DevFrontend/schemas/accessibility_review.schema.json` | Accessibility audit output |
| 19 | `Agente05_DevFrontend/schemas/responsive_layout.schema.json` | Responsive layout specifications |

---

## Template Files (7)

| # | File | Format |
|---|------|--------|
| 20 | `Agente05_DevFrontend/templates/Frontend_Implementation_Report.md` | Markdown |
| 21 | `Agente05_DevFrontend/templates/Server_Component_Template.tsx` | TypeScript/TSX |
| 22 | `Agente05_DevFrontend/templates/Client_Component_Template.tsx` | TypeScript/TSX |
| 23 | `Agente05_DevFrontend/templates/Loading_State_Template.tsx` | TypeScript/TSX |
| 24 | `Agente05_DevFrontend/templates/Error_State_Template.tsx` | TypeScript/TSX |
| 25 | `Agente05_DevFrontend/templates/Empty_State_Template.tsx` | TypeScript/TSX |
| 26 | `Agente05_DevFrontend/templates/Recharts_Component_Template.tsx` | TypeScript/TSX |

---

## Checklist Files (7)

| # | File | When to Run |
|---|------|------------|
| 27 | `Agente05_DevFrontend/checklists/frontend_quality_checklist.md` | Before every Gate 4 submission |
| 28 | `Agente05_DevFrontend/checklists/design_system_checklist.md` | After each component |
| 29 | `Agente05_DevFrontend/checklists/accessibility_checklist.md` | Before Gate 4 (interactive components) |
| 30 | `Agente05_DevFrontend/checklists/responsive_layout_checklist.md` | After layout components |
| 31 | `Agente05_DevFrontend/checklists/server_vs_client_component_checklist.md` | Before each component |
| 32 | `Agente05_DevFrontend/checklists/api_contract_usage_checklist.md` | Before data-consuming components |
| 33 | `Agente05_DevFrontend/checklists/runtime_isolation_checklist.md` | Task start + Gate 4 |

---

## Example Files (6)

| # | File | Type |
|---|------|------|
| 34 | `Agente05_DevFrontend/examples/good_component.tsx` | Good — Server Component best practices |
| 35 | `Agente05_DevFrontend/examples/bad_component.tsx` | Bad — all FM-01 through FM-09 |
| 36 | `Agente05_DevFrontend/examples/good_dashboard_view.tsx` | Good — full dashboard pattern |
| 37 | `Agente05_DevFrontend/examples/bad_dashboard_view.tsx` | Bad — all Client, useEffect, no states |
| 38 | `Agente05_DevFrontend/examples/good_frontend_report.md` | Good — complete Gate 4 report |
| 39 | `Agente05_DevFrontend/examples/bad_frontend_report.md` | Bad — vague, incomplete, false gate_ready |

---

## Skill Files (10 skills × 6 files = 60 files)

### Skill 1: server-component-selection-skill (files 40–45)
| # | File |
|---|------|
| 40 | `skills/server-component-selection-skill/skill.md` |
| 41 | `skills/server-component-selection-skill/input.schema.json` |
| 42 | `skills/server-component-selection-skill/output.schema.json` |
| 43 | `skills/server-component-selection-skill/checklist.md` |
| 44 | `skills/server-component-selection-skill/examples/good_output.md` |
| 45 | `skills/server-component-selection-skill/examples/bad_output.md` |

### Skill 2: nextjs-react-component-skill (files 46–51)
| # | File |
|---|------|
| 46 | `skills/nextjs-react-component-skill/skill.md` |
| 47 | `skills/nextjs-react-component-skill/input.schema.json` |
| 48 | `skills/nextjs-react-component-skill/output.schema.json` |
| 49 | `skills/nextjs-react-component-skill/checklist.md` |
| 50 | `skills/nextjs-react-component-skill/examples/good_output.md` |
| 51 | `skills/nextjs-react-component-skill/examples/bad_output.md` |

### Skill 3: tailwind-v4-design-system-skill (files 52–57)
| # | File |
|---|------|
| 52 | `skills/tailwind-v4-design-system-skill/skill.md` |
| 53 | `skills/tailwind-v4-design-system-skill/input.schema.json` |
| 54 | `skills/tailwind-v4-design-system-skill/output.schema.json` |
| 55 | `skills/tailwind-v4-design-system-skill/checklist.md` |
| 56 | `skills/tailwind-v4-design-system-skill/examples/good_output.md` |
| 57 | `skills/tailwind-v4-design-system-skill/examples/bad_output.md` |

### Skill 4: accessibility-check-skill (files 58–63)
| # | File |
|---|------|
| 58 | `skills/accessibility-check-skill/skill.md` |
| 59 | `skills/accessibility-check-skill/input.schema.json` |
| 60 | `skills/accessibility-check-skill/output.schema.json` |
| 61 | `skills/accessibility-check-skill/checklist.md` |
| 62 | `skills/accessibility-check-skill/examples/good_output.md` |
| 63 | `skills/accessibility-check-skill/examples/bad_output.md` |

### Skill 5: frontend-state-management-skill (files 64–69)
| # | File |
|---|------|
| 64 | `skills/frontend-state-management-skill/skill.md` |
| 65 | `skills/frontend-state-management-skill/input.schema.json` |
| 66 | `skills/frontend-state-management-skill/output.schema.json` |
| 67 | `skills/frontend-state-management-skill/checklist.md` |
| 68 | `skills/frontend-state-management-skill/examples/good_output.md` |
| 69 | `skills/frontend-state-management-skill/examples/bad_output.md` |

### Skill 6: swr-polling-skill (files 70–75)
| # | File |
|---|------|
| 70 | `skills/swr-polling-skill/skill.md` |
| 71 | `skills/swr-polling-skill/input.schema.json` |
| 72 | `skills/swr-polling-skill/output.schema.json` |
| 73 | `skills/swr-polling-skill/checklist.md` |
| 74 | `skills/swr-polling-skill/examples/good_output.md` |
| 75 | `skills/swr-polling-skill/examples/bad_output.md` |

### Skill 7: recharts-dashboard-skill (files 76–81)
| # | File |
|---|------|
| 76 | `skills/recharts-dashboard-skill/skill.md` |
| 77 | `skills/recharts-dashboard-skill/input.schema.json` |
| 78 | `skills/recharts-dashboard-skill/output.schema.json` |
| 79 | `skills/recharts-dashboard-skill/checklist.md` |
| 80 | `skills/recharts-dashboard-skill/examples/good_output.md` |
| 81 | `skills/recharts-dashboard-skill/examples/bad_output.md` |

### Skill 8: frontend-error-state-skill (files 82–87)
| # | File |
|---|------|
| 82 | `skills/frontend-error-state-skill/skill.md` |
| 83 | `skills/frontend-error-state-skill/input.schema.json` |
| 84 | `skills/frontend-error-state-skill/output.schema.json` |
| 85 | `skills/frontend-error-state-skill/checklist.md` |
| 86 | `skills/frontend-error-state-skill/examples/good_output.md` |
| 87 | `skills/frontend-error-state-skill/examples/bad_output.md` |

### Skill 9: responsive-layout-skill (files 88–93)
| # | File |
|---|------|
| 88 | `skills/responsive-layout-skill/skill.md` |
| 89 | `skills/responsive-layout-skill/input.schema.json` |
| 90 | `skills/responsive-layout-skill/output.schema.json` |
| 91 | `skills/responsive-layout-skill/checklist.md` |
| 92 | `skills/responsive-layout-skill/examples/good_output.md` |
| 93 | `skills/responsive-layout-skill/examples/bad_output.md` |

### Skill 10: design-token-compliance-skill (files 94–99)
| # | File |
|---|------|
| 94 | `skills/design-token-compliance-skill/skill.md` |
| 95 | `skills/design-token-compliance-skill/input.schema.json` |
| 96 | `skills/design-token-compliance-skill/output.schema.json` |
| 97 | `skills/design-token-compliance-skill/checklist.md` |
| 98 | `skills/design-token-compliance-skill/examples/good_output.md` |
| 99 | `skills/design-token-compliance-skill/examples/bad_output.md` |

---

## Build Report Files (4)

| # | File |
|---|------|
| 100 | `build/Agente05_DevFrontend_build_report.md` |
| 101 | `build/Agente05_DevFrontend_generated_files_index.md` |
| 102 | `build/Agente05_DevFrontend_runtime_readiness_checklist.md` |
| 103 | `build/Agente05_DevFrontend_knowledge_distillation_patch_report.md` |

---

**Total: 103 files**
