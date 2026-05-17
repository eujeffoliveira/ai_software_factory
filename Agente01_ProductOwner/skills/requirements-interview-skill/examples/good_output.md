# Requirements Interview Skill — Good Output Example

_GOOD EXAMPLE — Session 1 of an interview for a project management portal, with 8 questions across 4 categories and recorded stakeholder answers._

---

## Requirements_Interview_Log.md (Excerpt)

**Project:** Project Management Portal
**Date:** 2026-05-17
**Session:** 1 of 1
**Participants:** Product Manager (stakeholder), Operations Lead (stakeholder)

---

### Category 1 — Business Context

**Q1.1:** What specific problem does the current project tracking process have that this portal should solve?
**Answer:** Teams track project status in separate spreadsheets maintained by each project lead. There is no single view of all active projects. Management spends 2+ hours per week collecting status updates manually.
**Action Item:** Documented as business problem in PRD Section 2. No OQ created.

**Q1.2:** What does success look like 3 months after launch?
**Answer:** Management can see all project statuses in under 5 minutes, without asking project leads. We define that as "management gets a status overview in one screen without any manual compilation."
**Action Item:** Documented as OBJ-01 with measurable criterion.

---

### Category 2 — Target Users

**Q2.1:** Who are the primary users of the portal — the people who will use it daily?
**Answer:** Project Leads who update their project status. There are about 15 of them. They update weekly.
**Action Item:** Persona 1 = Project Lead. Documented in Target Users section.

**Q2.2:** Who are the secondary users?
**Answer:** Department Managers who need the consolidated view. They do not update — they only read.
**Action Item:** Persona 2 = Department Manager. Documented in Target Users section.

---

### Category 3 — Scope

**Q3.1:** Is budget tracking in scope for this version?
**Answer:** No. We only want project status (phase, health indicator, blockers). Budget is managed in a separate finance system and is out of scope.
**Action Item:** Budget tracking documented as out-of-scope in Scope_Boundary.md. Reason: managed in separate system.

**Q3.2:** Should project leads be able to create new projects themselves, or does that require admin approval?
**Answer:** Project leads cannot create projects — only the Operations Lead can create a new project. Project leads update status on existing projects.
**Action Item:** Documented as BR-001. Source: Operations Lead, Session 1.

---

### Category 5 — Business Rules

**Q5.1:** Can a project's health indicator be set to "Red" by the project lead without manager review?
**Answer:** Yes, project leads have full authority to set any status including Red. However, any Red project automatically triggers a notification to the department manager.
**Action Item:** BR-002 created: "Setting project health to Red triggers immediate notification to assigned department manager." Source: Operations Lead, Session 1.

**Q5.2:** How long should project history be retained?
**Answer:** At least 3 years. We have audit requirements.
**Action Item:** NFR-DRET-001 created: project records retained for 3 years. No OQ needed.

---

## Initial Open_Questions.md

| ID | Question | Impact | Criticality | Owner | Status |
|---|---|---|---|---|---|
| OQ-001 | Should archived projects be visible to all users or only to admins and the original project lead? | Affects user story for project history view and authorization business rule | HIGH | Operations Lead | Open |
| OQ-002 | Is there a maximum number of active projects visible in the consolidated dashboard? | Affects layout and NFR-SCALE story; may need pagination if large numbers expected | LOW | Product Manager | Open |

---

## Why This is Good

- 8 questions across 4 categories — not all the same type
- Answers are specific and actionable ("Budget is managed in a separate system and is out of scope" not "maybe")
- Action items are precise: BR-001 with source, NFR-DRET-001 with value, out-of-scope documented
- 2 open questions created — each with impact, criticality, and owner
- OQ-001 criticality is HIGH (it affects authorization design); OQ-002 is LOW (does not block any story)
- No technology questions asked ("What database?", "REST or GraphQL?")
