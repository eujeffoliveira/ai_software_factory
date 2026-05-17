# adr-authoring-skill Checklist

## Pre-execution
- [ ] `decision_context` is provided and describes the forcing function (not just the conclusion)
- [ ] At least one PRD requirement ID is identified to trace this decision
- [ ] Existing ADR files scanned to determine the next available NNN
- [ ] `context_view.md §4` (ADR Governance) and `§1.3` (deviation categories) reviewed
- [ ] At least 2 alternatives identified, including the Golden Path default if applicable

## During execution
- [ ] ADR number assigned without collision with existing IDs
- [ ] Title written as "Use X instead of Y for Z" or equivalent clear statement
- [ ] Status set to `PROPOSED` — not ACCEPTED, not blank, not APPROVED
- [ ] Context section explains the problem/forcing function (3–5 sentences minimum)
- [ ] Decision section starts with "We will…"
- [ ] Each alternative has: what it is, why considered, why rejected or chosen
- [ ] Golden Path default is one of the documented alternatives
- [ ] Consequences list at least 1 positive and 1 negative item
- [ ] PRD requirement ID cited in the traceability section
- [ ] Filename pattern enforced: `ADR-NNN-kebab-case-title.md`

## Post-execution
- [ ] ADR file written to `docs/adr/ADR-NNN-kebab-case-title.md`
- [ ] One-line entry added to `Architecture_Decisions.md`
- [ ] Gate blocking status confirmed: Tech Lead notified that `BLOCKED_PENDING_ADR` is active
- [ ] No self-approval attempted — decision awaits Tech Lead review

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/`, `Agente02_SoftwareArchitect/context_view.md`, project artifacts provided as input only
