# usability-review-skill Execution Checklist
## Agente09_UxUiDesigner

---

## Pre-Execution

- [ ] UX_Flow.md, Wireframes.md, UI_Spec.md, Screen_States.md all present
- [ ] All ui-state-design-skill checklists have been completed for all components
- [ ] This is the final review step before Handoff Package assembly

---

## Review Execution

- [ ] Cognitive load review completed (P1, P3 — Hick's Law, Miller's Law)
- [ ] Navigation clarity review completed (P5, H2 — conventions)
- [ ] Form usability review completed (P10, H4 — error-first form design)
- [ ] Error prevention review completed (P10, H15 — destructive action friction)
- [ ] Visual hierarchy review completed (P4, H1 — proximity, 5-second rule)
- [ ] Mobile usability review completed (P12, H10, DR010)
- [ ] Feedback and system status review completed (P9 — confirmation, loading)
- [ ] Component reuse check completed (DR003, H8)
- [ ] Empty state quality review completed (H6, Card 009)
- [ ] Error message copy review completed (H9, Card 008)

---

## Issues Processing

- [ ] All critical issues have been fixed in the design artifacts
- [ ] All high issues have been fixed in the design artifacts
- [ ] Medium/low issues are documented in the issues log with deferred/accepted status
- [ ] Design artifacts updated where fixes were made

---

## Checklist Completion

- [ ] `checklists/usability_checklist.md` template completed section by section
- [ ] Each section has a PASS or FAIL status
- [ ] Overall verdict determined: PASS / PASS WITH NOTES / FAIL
- [ ] Deferred issues table populated (medium/low only)

---

## Post-Execution

- [ ] `ready_for_handoff: true` can be set (verdict is PASS or PASS_WITH_NOTES)
- [ ] Output schema fields completed (verdict, issues_found, critical_unresolved, high_unresolved)

---

## Runtime Knowledge Policy

This skill checklist accesses only local distilled knowledge at runtime:
- `Agente09_UxUiDesigner/knowledge/principles.md` — all principles
- `Agente09_UxUiDesigner/knowledge/heuristics.md` — all heuristics
- `Agente09_UxUiDesigner/knowledge/knowledge_cards.md` — all cards
- `Agente09_UxUiDesigner/knowledge/decision_rules.md` — DR001–DR015
- `Agente09_UxUiDesigner/checklists/usability_checklist.md`
- `Agente09_UxUiDesigner/templates/Usability_Checklist.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any source outside `Agente09_UxUiDesigner/`
