# Runtime Isolation Checklist
## Agente09_UxUiDesigner
## Apply at start of every session and before any skill execution

---

## Purpose

This checklist enforces the core architectural rule of the AI Software Factory: **build-time sources are never consulted at runtime**. The agent reads only from its own `Agente09_UxUiDesigner/` folder and input project artifacts.

---

## Before Starting Any Design Task

- [ ] **All sources I am consulting are inside `Agente09_UxUiDesigner/`** or are project input artifacts (PRD.md, Architecture.md, API_Contract.json)
- [ ] **I am NOT reading from `context/`** — no `context/base_teorica.md`, `context/integrantes.md`, `context/reference_architecture_generico.md`, or any other file in `context/`
- [ ] **I am NOT reading from `lib/`** — no PDF files, no raw bibliography, no `lib/UxUiDesigner/` folder
- [ ] **I am NOT reading any `*.pdf` file** — raw books are build-time only
- [ ] **I am NOT accessing global architecture documents** outside my agent folder

---

## Allowed Runtime Sources

Confirm that every source I am using is on this allowed list:

- [ ] `Agente09_UxUiDesigner/prompt.md`
- [ ] `Agente09_UxUiDesigner/agent_config.json`
- [ ] `Agente09_UxUiDesigner/context_view.md`
- [ ] `Agente09_UxUiDesigner/rag_manifest.json`
- [ ] `Agente09_UxUiDesigner/skills_manifest.md`
- [ ] `Agente09_UxUiDesigner/quality_gate.md`
- [ ] `Agente09_UxUiDesigner/handoff_schema.json`
- [ ] `Agente09_UxUiDesigner/failure_modes.md`
- [ ] `Agente09_UxUiDesigner/schemas/` (any file)
- [ ] `Agente09_UxUiDesigner/templates/` (any file)
- [ ] `Agente09_UxUiDesigner/checklists/` (any file)
- [ ] `Agente09_UxUiDesigner/examples/` (any file)
- [ ] `Agente09_UxUiDesigner/skills/` (any file)
- [ ] `Agente09_UxUiDesigner/knowledge/principles.md`
- [ ] `Agente09_UxUiDesigner/knowledge/heuristics.md`
- [ ] `Agente09_UxUiDesigner/knowledge/decision_rules.md`
- [ ] `Agente09_UxUiDesigner/knowledge/knowledge_cards.md`
- [ ] Project artifacts provided as input: `PRD.md`, `Architecture.md`, `API_Contract.json`, `DB_Schema`

Note: `Agente09_UxUiDesigner/knowledge/source_map.json` is NOT used at runtime — it is a build-time traceability document.

---

## Blocked Sources (Explicit Confirmation)

Confirm that NONE of the following are being accessed:

- [ ] `context/` — entire folder is blocked at runtime
- [ ] `context/base_teorica.md` — blocked
- [ ] `context/reference_architecture_generico.md` — blocked
- [ ] `context/integrantes.md` — blocked
- [ ] `context/manual_arquitetura_componentes_generico.md` — blocked
- [ ] `lib/` — entire folder is blocked at runtime
- [ ] `lib/UxUiDesigner/` — blocked
- [ ] Any `*.pdf` file — blocked
- [ ] Any file in another agent's folder not provided as project input — blocked

---

## When Using Knowledge

If I need UX/UI design principles at runtime, I consult:
- `Agente09_UxUiDesigner/knowledge/principles.md` — NOT the original book
- `Agente09_UxUiDesigner/knowledge/heuristics.md` — NOT the original book
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — NOT the original book
- `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` — NOT the original book

If I need tech stack context, I consult:
- `Agente09_UxUiDesigner/context_view.md` — NOT `context/reference_architecture_generico.md`

---

## Escalation Path

If I encounter a situation where I believe I need to consult a blocked source to complete the task:

1. **Stop** — do not access the blocked source
2. **Identify** what information is missing from my local knowledge base
3. **Escalate** to Agente00_TechLead with a specific question: "My local knowledge does not cover [X]. Is there a way to resolve this within the project context?"
4. **Wait** for resolution before proceeding

---

## Verdict

- [ ] **COMPLIANT** — All accessed sources are on the allowed list; no blocked sources accessed
- [ ] **NON-COMPLIANT** — A blocked source was accessed or almost accessed; stop and escalate
