# Agente09_UxUiDesigner — Runtime Readiness Checklist
## Build Date: 2026-05-17
## Status: READY

---

## Core Identity

- [x] `prompt.md` present and complete — 10 operating principles, workflow, escalation policy, handoff format
- [x] `agent_config.json` present — `blocked_runtime_sources` includes `context/`, `lib/`, `*.pdf`
- [x] `agent_config.json` present — `allowed_runtime_sources` lists all agent-local paths
- [x] Agent role is clearly defined — optional specialist in the factory pipeline
- [x] Pipeline position documented — receives from Agente01+02 via Tech Lead, delivers to Agente05

---

## Runtime Isolation

- [x] `context/` is in `blocked_runtime_sources`
- [x] `lib/` is in `blocked_runtime_sources`
- [x] `*.pdf` is in `blocked_runtime_sources`
- [x] `context/reference_architecture_generico.md` is in `blocked_runtime_sources`
- [x] `context/base_teorica.md` is in `blocked_runtime_sources`
- [x] `runtime_isolation_checklist.md` present for runtime enforcement
- [x] Every `skill.md` has a `## Knowledge Access Policy` section
- [x] Every `checklist.md` has a `## Runtime Knowledge Policy` item

---

## Context View

- [x] `context_view.md` present and covers all runtime-needed context:
  - [x] Pipeline position (§1)
  - [x] Frontend tech stack design implications (§2)
  - [x] UX Flow conventions (§3)
  - [x] Wireframe ASCII conventions (§4)
  - [x] UI Specification conventions (§5)
  - [x] Design tokens (§6)
  - [x] Screen state specifications (§7)
  - [x] WCAG 2.1 AA requirements (§8)
  - [x] Recharts design specs (§9)
  - [x] Anti-patterns (§10)

---

## Knowledge Base

- [x] `knowledge/principles.md` — 12 principles (P1–P12)
- [x] `knowledge/heuristics.md` — 15 heuristics (H1–H15)
- [x] `knowledge/decision_rules.md` — 15 rules (DR001–DR015)
- [x] `knowledge/knowledge_cards.md` — 12 cards (Cards 001–012)
- [x] `knowledge/source_map.json` — build-time source tracking (not used at runtime)

---

## Operational Artifacts

- [x] `quality_gate.md` — Design Review pre-condition with 5 status codes and blocking conditions
- [x] `handoff_schema.json` — JSON Schema for Design Package Handoff
- [x] `failure_modes.md` — 8 failure modes (FM-01 through FM-08)
- [x] `rag_manifest.json` — 6 knowledge collections

---

## Skills

- [x] `skills_manifest.md` — All 5 skills indexed with triggers
- [x] `ux-flow-design-skill` — 6 files complete (skill.md, 2 schemas, checklist, 2 examples)
- [x] `wireframe-spec-skill` — 6 files complete
- [x] `ui-state-design-skill` — 6 files complete
- [x] `usability-review-skill` — 6 files complete
- [x] `design-system-application-skill` — 6 files complete

---

## Schemas

- [x] `schemas/ux_flow.schema.json` — UX Flow validation
- [x] `schemas/wireframe.schema.json` — Wireframe metadata validation
- [x] `schemas/ui_spec.schema.json` — UI Spec component summary validation
- [x] `schemas/usability_checklist.schema.json` — Usability review validation
- [x] `schemas/screen_state.schema.json` — Screen state specification validation

---

## Templates

- [x] `templates/UX_Flow.md` — Usable template with all required sections
- [x] `templates/Wireframes.md` — Usable template with ASCII wireframe syntax
- [x] `templates/UI_Spec.md` — Usable template with TypeScript interface, states, accessibility
- [x] `templates/Usability_Checklist.md` — 8-section review template
- [x] `templates/Screen_States.md` — 4-state specification template

---

## Checklists

- [x] `checklists/ux_flow_checklist.md`
- [x] `checklists/wireframe_quality_checklist.md`
- [x] `checklists/ui_spec_checklist.md`
- [x] `checklists/usability_checklist.md`
- [x] `checklists/design_system_application_checklist.md`
- [x] `checklists/accessibility_basics_checklist.md`
- [x] `checklists/runtime_isolation_checklist.md`

---

## Examples

- [x] `examples/good_ux_flow.md` — Positive example with full annotation
- [x] `examples/bad_ux_flow.md` — Negative example with failure mode annotations
- [x] `examples/good_wireframe.md` — Positive example with desktop + mobile
- [x] `examples/bad_wireframe.md` — Negative example with failure mode annotations
- [x] `examples/good_ui_spec.md` — Positive example with all 4 states, accessibility, tokens
- [x] `examples/bad_ui_spec.md` — Negative example with hardcoded colors, missing states

---

## Golden Path Alignment

- [x] Design tokens reference Next.js/Tailwind CSS v4 stack
- [x] Loading states use `loading.tsx` / Suspense convention
- [x] Image specifications reference `next/image` dimensions
- [x] Charts reference Recharts v3
- [x] TypeScript interfaces use correct types for Next.js serialized props
- [x] Responsive breakpoints match Tailwind v4 (sm: md: lg: xl:)

---

## White-Label Compliance

- [x] Zero org-specific names in any artifact (no raiz-orange, no raiz-teal, no brand names)
- [x] Design tokens are generic: `primary-color`, `secondary-color`, etc.
- [x] All templates use `[entity]`, `[organization]`, `[stakeholder]` placeholders
- [x] `context_view.md` mentions no organization name

---

## Overall Verdict

**STATUS: READY FOR RUNTIME**

All 70 files present. Runtime isolation enforced. Knowledge base complete. All 5 skills operational. Templates and checklists usable. Examples provide positive and negative guidance for all primary artifacts.

The agent is ready to be activated by Agente00_TechLead for design tasks.
