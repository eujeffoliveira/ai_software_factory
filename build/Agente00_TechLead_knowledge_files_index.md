# Agente00_TechLead — Knowledge Files Index

**Patch Date:** 2026-05-17

---

## New: `knowledge/` Directory

```
Agente00_TechLead/knowledge/
├── principles.md          — 10 operational principles
├── heuristics.md          — 12 practical decision heuristics
├── decision_rules.md      — 31 actionable if-then rules
├── knowledge_cards.md     — 10 reusable concept cards
└── source_map.json        — build-time source → artifact mapping
```

### `principles.md` Content Summary
- P1: Orchestrate, do not replace specialists
- P2: No gate advances without mandatory artifact
- P3: Serious risk requires blocking or human escalation
- P4: Any Golden Path deviation requires an ADR
- P5: Production deployment requires rollback and human approval
- P6: State Ledger is always current
- P7: QA and DevSecOps can block — Tech Lead cannot override
- P8: Runtime uses only local distilled knowledge
- P9: Bibliography is build-time only
- P10: Council before irreversible or high-stakes decisions

### `heuristics.md` Content Summary
- H1: Handoff Package absent → reject delivery
- H2: PRD no testable criteria → return to Product Owner
- H3: Architecture deviates without ADR → block Gate 2
- H4: Task > 5 story points → return to Task Planner
- H5: QA fails blocker → return to developer
- H6: DevSecOps blocks → no Gate 5 approval
- H7: Deploy plan no rollback → block Gate 6
- H8: Irreversible decision → escalate to human
- H9: Runtime tries raw PDF/bibliography → refuse, use knowledge/
- H10: CRITICAL risk no mitigation → block current gate
- H11: Council no consensus → escalate to human
- H12: Source not in approved RAG → do not retrieve

### `decision_rules.md` Content Summary
- DR001–DR008: Agent routing rules (all 7 gates + RETURNED routing)
- DR009–DR012: Gate approval rules (artifact missing, handoff incomplete, CRITICAL risk, Gate 6 human)
- DR013–DR016: ADR rules (technology, pattern, retroactive, resolution)
- DR017–DR020: Council activation rules (technology, multi-agent, CRITICAL risk, irreversible)
- DR021–DR025: Human escalation rules (production, destructive migration, scope 20%, conflict, budget)
- DR026–DR028: QA and security block rules
- DR029–DR031: Knowledge distillation rules (missing knowledge, raw access violation, new sources)

### `knowledge_cards.md` Content Summary
- Card 001: State Ledger
- Card 002: Handoff Package
- Card 003: Quality Gates (1–7)
- Card 004: ADR (Architecture Decision Record)
- Card 005: Tech Lead Council
- Card 006: Runtime Isolation
- Card 007: Build-Time Knowledge Distillation
- Card 008: Human Escalation
- Card 009: Risk Register
- Card 010: Golden Model (Tech Stack)

---

## Updated Files (Outside `knowledge/`)

| File | What Changed |
|------|-------------|
| `agent_config.json` | Added `knowledge/` to allowed sources; expanded blocked sources; added `runtime_knowledge_policy` |
| `prompt.md` | Added `knowledge/` to Runtime Context Rule; added `Build-Time Knowledge Distillation Policy` section |
| `context_view.md` | Added `Knowledge Distillation Boundary` section |
| `rag_manifest.json` | Added `raw_sources_policy` and `local_distilled_sources` |
| `skills_manifest.md` | Added `Knowledge Distillation Rule for Skills` section |
| `failure_modes.md` | Added FM-15 and FM-16 |
| `checklists/runtime_isolation_checklist.md` | Added `knowledge/` to allowed; added `Knowledge Distillation Checks` section |

---

## Updated Skills

| Skill | Files Changed |
|-------|--------------|
| `state-ledger-management-skill` | `skill.md`, `checklist.md` |
| `agent-routing-skill` | `skill.md`, `checklist.md` |
| `artifact-contract-validation-skill` | `skill.md`, `checklist.md` |
| `tollgate-decision-skill` | `skill.md`, `checklist.md` |
| `council-mediation-skill` | `skill.md`, `checklist.md` |
| `adr-governance-skill` | `skill.md`, `checklist.md` |
| `human-escalation-skill` | `skill.md`, `checklist.md` |
| `risk-register-management-skill` | `skill.md`, `checklist.md` |
| `progress-reporting-skill` | `skill.md`, `checklist.md` |

---

## Total Patch Change Count

| Category | New | Updated |
|----------|-----|---------|
| knowledge/ files | 5 | 0 |
| Core agent files | 0 | 7 |
| Skill files (skill.md) | 0 | 9 |
| Skill files (checklist.md) | 0 | 9 |
| Build reports | 3 | 0 |
| **Total** | **8** | **25** |
