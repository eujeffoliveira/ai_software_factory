# Runtime Isolation Checklist

**Agent:** Agente05_DevFrontend
**Run:** At the start of each task session AND before Gate 4 submission

## Purpose

This checklist enforces the core architectural rule: **at runtime, this agent reads ONLY from `Agente05_DevFrontend/`**. It never accesses `context/`, `lib/`, raw book files, or any global source.

---

## Runtime Knowledge Policy

> This checklist is self-referential — it enforces the isolation rule itself. All knowledge used to complete tasks must come from within `Agente05_DevFrontend/`. If you find yourself needing to read from `context/` or `lib/`, stop and use the distilled knowledge in `knowledge/` instead.

---

## Section 1: Allowed Runtime Sources

Confirm these sources are available and will be consulted:

- [ ] **SRC-01** `Agente05_DevFrontend/prompt.md` — role, mission, operating principles
- [ ] **SRC-02** `Agente05_DevFrontend/context_view.md` — compiled frontend patterns and rules
- [ ] **SRC-03** `Agente05_DevFrontend/knowledge/principles.md` — P1–P12
- [ ] **SRC-04** `Agente05_DevFrontend/knowledge/heuristics.md` — H1–H15
- [ ] **SRC-05** `Agente05_DevFrontend/knowledge/decision_rules.md` — DR001–DR020
- [ ] **SRC-06** `Agente05_DevFrontend/knowledge/knowledge_cards.md` — Card 001–012
- [ ] **SRC-07** `Agente05_DevFrontend/skills/` — skill.md for relevant skills
- [ ] **SRC-08** `Agente05_DevFrontend/templates/` — TSX templates
- [ ] **SRC-09** `Agente05_DevFrontend/checklists/` — quality checklists
- [ ] **SRC-10** `Agente05_DevFrontend/schemas/` — JSON schemas
- [ ] **SRC-11** `Agente05_DevFrontend/examples/` — good/bad examples
- [ ] **SRC-12** Project input artifacts: `API_Contract.json`, `Execution_Plan.json`, `Architecture.md`, existing codebase files

---

## Section 2: Blocked Runtime Sources

Confirm these sources are NOT accessed during task execution:

- [ ] **BLOCK-01** `context/` folder — NOT accessed
- [ ] **BLOCK-02** `lib/` folder — NOT accessed
- [ ] **BLOCK-03** `*.pdf` files — NOT accessed
- [ ] **BLOCK-04** `context/manual_arquitetura_componentes_generico.md` — NOT accessed
- [ ] **BLOCK-05** `context/reference_architecture_generico.md` — NOT accessed
- [ ] **BLOCK-06** `context/integrantes.md` — NOT accessed
- [ ] **BLOCK-07** `context/base_teorica.md` — NOT accessed
- [ ] **BLOCK-08** Any other agent's folder (Agente01–Agente04, Agente06–Agente10) — NOT accessed
- [ ] **BLOCK-09** `build/` folder — NOT accessed

---

## Section 3: Knowledge Distillation Verification

For each concept used in the task, verify it came from the local knowledge folder:

- [ ] **KNOW-01** Component type decision → from `knowledge/decision_rules.md` DR001–DR006
- [ ] **KNOW-02** Design token names → from `context_view.md` § 12 Design Token Reference
- [ ] **KNOW-03** Tailwind patterns → from `context_view.md` § 3 Tailwind v4 Patterns
- [ ] **KNOW-04** Loading state pattern → from `context_view.md` § 4 Loading State Pattern
- [ ] **KNOW-05** Error state pattern → from `context_view.md` § 5 Error State Pattern
- [ ] **KNOW-06** Empty state pattern → from `context_view.md` § 6 Empty State Pattern
- [ ] **KNOW-07** Recharts pattern → from `context_view.md` § 7 Recharts Pattern
- [ ] **KNOW-08** SWR pattern → from `context_view.md` § 8 SWR Pattern
- [ ] **KNOW-09** Server Action integration → from `context_view.md` § 9 Server Action Integration
- [ ] **KNOW-10** Accessibility patterns → from `context_view.md` § 13 Accessibility Patterns

---

## Section 4: Output Verification

Verify the produced artifacts comply with runtime isolation:

- [ ] **OUT-01** Implementation Report references only local Agente05 files and project input artifacts
- [ ] **OUT-02** No references to `context/` in any produced documentation
- [ ] **OUT-03** No references to `lib/` or book titles in implementation code comments
- [ ] **OUT-04** Handoff Package references only project artifacts and `Agente06_QaEngineer`

---

**Sign-off:** Runtime isolation confirmed — all knowledge from local `Agente05_DevFrontend/` sources only
