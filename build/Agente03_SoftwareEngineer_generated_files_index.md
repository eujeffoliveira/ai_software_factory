# Agente03 — Generated Files Index
## Build Date: 2026-05-17
## Edition: generic-white-label
## Total Files: 88

---

## Core Agent Files (8)

| File | Description |
|------|-------------|
| `Agente03_SoftwareEngineer/prompt.md` | System prompt: role, principles, workflow, escalation |
| `Agente03_SoftwareEngineer/agent_config.json` | Runtime config: allowed/blocked sources, capabilities, Golden Path |
| `Agente03_SoftwareEngineer/context_view.md` | Compiled local context (replaces build-time sources at runtime) |
| `Agente03_SoftwareEngineer/rag_manifest.json` | RAG policy: 6 collections, retrieval rules |
| `Agente03_SoftwareEngineer/skills_manifest.md` | Index of all 7 skills |
| `Agente03_SoftwareEngineer/quality_gate.md` | Gate 3 — Execution Plan Review |
| `Agente03_SoftwareEngineer/handoff_schema.json` | JSON Schema for Gate 3 handoff package |
| `Agente03_SoftwareEngineer/failure_modes.md` | 10 failure modes with remediation |

---

## Knowledge Files (5)

| File | Description |
|------|-------------|
| `Agente03_SoftwareEngineer/knowledge/principles.md` | P1–P8 operational principles |
| `Agente03_SoftwareEngineer/knowledge/heuristics.md` | H1–H10 decision heuristics |
| `Agente03_SoftwareEngineer/knowledge/decision_rules.md` | DR001–DR014 binding decision rules |
| `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` | Card001–Card010 concept references |
| `Agente03_SoftwareEngineer/knowledge/source_map.json` | Build-time source → artifact traceability |

---

## Schema Files (7)

| File | Description |
|------|-------------|
| `Agente03_SoftwareEngineer/schemas/execution_plan.schema.json` | Validates Execution_Plan.json |
| `Agente03_SoftwareEngineer/schemas/task.schema.json` | Validates individual task objects |
| `Agente03_SoftwareEngineer/schemas/dependency_graph.schema.json` | Validates dependency graph structure |
| `Agente03_SoftwareEngineer/schemas/task_handoff.schema.json` | Validates per-task handoff package |
| `Agente03_SoftwareEngineer/schemas/task_acceptance_criteria.schema.json` | Validates acceptance criteria |
| `Agente03_SoftwareEngineer/schemas/task_security_requirements.schema.json` | Validates security requirements |
| `Agente03_SoftwareEngineer/schemas/task_test_requirements.schema.json` | Validates test requirements |

---

## Template Files (6)

| File | Description |
|------|-------------|
| `Agente03_SoftwareEngineer/templates/Execution_Plan.json` | Execution plan with 3 example tasks |
| `Agente03_SoftwareEngineer/templates/Task_Backlog.md` | Task backlog organized by type |
| `Agente03_SoftwareEngineer/templates/Dependency_Graph.md` | Dependency graph with Mermaid chart |
| `Agente03_SoftwareEngineer/templates/Task_Template.md` | Single task template with all fields |
| `Agente03_SoftwareEngineer/templates/Task_Handoff_Package.md` | Per-task handoff for dev agents |
| `Agente03_SoftwareEngineer/templates/Implementation_Sequence.md` | 4-phase implementation sequence |

---

## Checklist Files (7)

| File | Description |
|------|-------------|
| `Agente03_SoftwareEngineer/checklists/task_atomicity_checklist.md` | Verifies task atomicity |
| `Agente03_SoftwareEngineer/checklists/dependency_checklist.md` | Verifies dependency graph |
| `Agente03_SoftwareEngineer/checklists/implementation_readiness_checklist.md` | Definition of Ready |
| `Agente03_SoftwareEngineer/checklists/context_window_checklist.md` | Context window risk checks |
| `Agente03_SoftwareEngineer/checklists/test_requirements_checklist.md` | Test requirements completeness |
| `Agente03_SoftwareEngineer/checklists/security_requirements_checklist.md` | Security requirements completeness |
| `Agente03_SoftwareEngineer/checklists/runtime_isolation_checklist.md` | Build/runtime isolation verification |

---

## Example Files (6)

| File | Description |
|------|-------------|
| `Agente03_SoftwareEngineer/examples/good_execution_plan.json` | Well-formed 8-task plan for TaskFlow SaaS |
| `Agente03_SoftwareEngineer/examples/bad_execution_plan.json` | Broken plan with annotated problems |
| `Agente03_SoftwareEngineer/examples/good_task.md` | TASK-003 createTask Server Action (exemplary) |
| `Agente03_SoftwareEngineer/examples/bad_task.md` | "Do the backend stuff" (all problems annotated) |
| `Agente03_SoftwareEngineer/examples/good_dependency_graph.md` | Valid 8-task graph with Mermaid |
| `Agente03_SoftwareEngineer/examples/bad_dependency_graph.md` | Circular dependency + missing nodes |

---

## Skill Files (42 = 7 skills × 6 files)

### execution-plan-generation-skill (6 files)
| File | Description |
|------|-------------|
| `skills/execution-plan-generation-skill/skill.md` | Purpose, procedure, knowledge policy |
| `skills/execution-plan-generation-skill/input.schema.json` | Input validation schema |
| `skills/execution-plan-generation-skill/output.schema.json` | Output validation schema |
| `skills/execution-plan-generation-skill/checklist.md` | Pre/execution/post checks |
| `skills/execution-plan-generation-skill/examples/good_output.md` | Well-formed 3-task plan fragment |
| `skills/execution-plan-generation-skill/examples/bad_output.md` | Mega-task with all problems |

### atomic-task-decomposition-skill (6 files)
| File | Description |
|------|-------------|
| `skills/atomic-task-decomposition-skill/skill.md` | Decomposition procedure |
| `skills/atomic-task-decomposition-skill/input.schema.json` | Component input schema |
| `skills/atomic-task-decomposition-skill/output.schema.json` | Task array output schema |
| `skills/atomic-task-decomposition-skill/checklist.md` | Decomposition checks |
| `skills/atomic-task-decomposition-skill/examples/good_output.md` | Auth feature → 5 tasks |
| `skills/atomic-task-decomposition-skill/examples/bad_output.md` | Auth feature as one XL task |

### dependency-graph-skill (6 files)
| File | Description |
|------|-------------|
| `skills/dependency-graph-skill/skill.md` | Graph building procedure |
| `skills/dependency-graph-skill/input.schema.json` | Task list input |
| `skills/dependency-graph-skill/output.schema.json` | Graph with topological order |
| `skills/dependency-graph-skill/checklist.md` | Cycle + sort checks |
| `skills/dependency-graph-skill/examples/good_output.md` | Valid acyclic 6-task graph |
| `skills/dependency-graph-skill/examples/bad_output.md` | Circular dependency graph |

### task-sizing-skill (6 files)
| File | Description |
|------|-------------|
| `skills/task-sizing-skill/skill.md` | Sizing procedure with LOC heuristics |
| `skills/task-sizing-skill/input.schema.json` | Task list with file paths |
| `skills/task-sizing-skill/output.schema.json` | Annotated tasks + warnings |
| `skills/task-sizing-skill/checklist.md` | XL check + plan-level checks |
| `skills/task-sizing-skill/examples/good_output.md` | 5 properly sized S/M tasks |
| `skills/task-sizing-skill/examples/bad_output.md` | 1 XL task blocking Gate 3 |

### acceptance-criteria-mapping-skill (6 files)
| File | Description |
|------|-------------|
| `skills/acceptance-criteria-mapping-skill/skill.md` | Mapping procedure |
| `skills/acceptance-criteria-mapping-skill/input.schema.json` | PRD criteria + task list |
| `skills/acceptance-criteria-mapping-skill/output.schema.json` | Tasks with criteria + coverage matrix |
| `skills/acceptance-criteria-mapping-skill/checklist.md` | Coverage completeness checks |
| `skills/acceptance-criteria-mapping-skill/examples/good_output.md` | 4 criteria → 4 tasks, all covered |
| `skills/acceptance-criteria-mapping-skill/examples/bad_output.md` | 2 uncovered criteria |

### implementation-sequencing-skill (6 files)
| File | Description |
|------|-------------|
| `skills/implementation-sequencing-skill/skill.md` | Phasing procedure |
| `skills/implementation-sequencing-skill/input.schema.json` | Topological order + tasks |
| `skills/implementation-sequencing-skill/output.schema.json` | Phases with parallelism |
| `skills/implementation-sequencing-skill/checklist.md` | Phase assignment checks |
| `skills/implementation-sequencing-skill/examples/good_output.md` | 3-phase sequence with parallelism |
| `skills/implementation-sequencing-skill/examples/bad_output.md` | Frontend before infrastructure |

### context-window-risk-analysis-skill (6 files)
| File | Description |
|------|-------------|
| `skills/context-window-risk-analysis-skill/skill.md` | Risk scoring procedure |
| `skills/context-window-risk-analysis-skill/input.schema.json` | Full execution plan |
| `skills/context-window-risk-analysis-skill/output.schema.json` | Risk report with per-task scores |
| `skills/context-window-risk-analysis-skill/checklist.md` | XL + L + mitigation checks |
| `skills/context-window-risk-analysis-skill/examples/good_output.md` | LOW risk, 8 tasks, gate_ready: true |
| `skills/context-window-risk-analysis-skill/examples/bad_output.md` | CRITICAL risk, 2 XL tasks |

---

## Build Report Files (7)

| File | Description |
|------|-------------|
| `build/Agente03_SoftwareEngineer_scan_report.md` | Sources found, risks, output summary |
| `build/Agente03_SoftwareEngineer_context_routing_plan.md` | Source → artifact routing map |
| `build/Agente03_SoftwareEngineer_bibliography_inventory.json` | 5 bibliography sources with concepts |
| `build/Agente03_SoftwareEngineer_generated_files_index.md` | This file |
| `build/Agente03_SoftwareEngineer_build_report.md` | Complete build report |
| `build/Agente03_SoftwareEngineer_runtime_readiness_checklist.md` | Runtime readiness verification |
| `build/Agente03_SoftwareEngineer_knowledge_distillation_patch_report.md` | Distillation report |
