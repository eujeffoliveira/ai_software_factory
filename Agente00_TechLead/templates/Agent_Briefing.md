# Agent Briefing — {{TARGET_AGENT}}

**Phase:** {{PHASE}}
**Gate Target:** Gate {{GATE_NUMBER}}
**Project:** {{PROJECT_NAME}}
**Date:** {{DATE}}
**Issued by:** Agente00_TechLead

---

## Task

{{Clear, specific task description. What this agent must produce in this interaction. Not vague — specify the deliverable.}}

---

## Inputs Available

- [ ] {{input_1}} — {{status: provided / pending}}
- [ ] {{input_2}} — {{status: provided / pending}}
- [ ] {{input_3}} — {{status: provided / pending}}

---

## Expected Outputs

- `{{artifact_1}}` — {{brief description}}
- `{{artifact_2}}` — {{brief description}}
- Handoff Package (mandatory)

---

## Constraints

- {{constraint_1 — e.g., "Must adhere to Golden Model: Next.js 16, proxy.ts, Prisma 7"}}
- {{constraint_2 — e.g., "ADR-001 is approved — use Redis for caching, not Vercel Edge"}}
- {{constraint_3}}

---

## Open Questions to Address

{{List unresolved questions from previous phases that this agent must address in their output.}}

- [ ] {{question_1}}
- [ ] {{question_2}}

---

## Risks to Consider

{{Registered risks relevant to this agent's task.}}

- **{{risk_1}}** ({{severity}}) — {{mitigation note}}
- **{{risk_2}}** ({{severity}}) — {{mitigation note}}

---

## Golden Model Reminders

{{Specific technical rules this agent must follow — pulled from context_view.md.}}

- {{reminder_1 — e.g., "Never write business logic in route.ts"}}
- {{reminder_2 — e.g., "Use prisma migrate deploy in staging and production — never prisma db push"}}
- {{reminder_3}}

---

## ADRs in Scope

{{List any ADRs the agent must respect for this task.}}

- {{ADR-001: description}} — {{status: Approved}}
- {{None if no ADRs apply}}

---

## Escalation Policy

If during execution you encounter:
- A conflict with the Golden Model that cannot be resolved with the existing ADRs → stop and alert Tech Lead
- A scope question → stop and alert Tech Lead (do not assume)
- A security concern → stop and alert Tech Lead immediately
- A missing artifact or unclear contract → stop and alert Tech Lead
