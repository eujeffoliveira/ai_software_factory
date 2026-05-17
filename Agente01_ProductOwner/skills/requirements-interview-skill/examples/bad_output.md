# Requirements Interview Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

---

## Requirements_Interview_Log.md (WRONG)

**Project:** Portal
**Date:** today

---

### Questions

1. What database should we use?
   **Answer:** PostgreSQL probably.

<!-- PROBLEMA: Technology question — "what database?" is not a product owner question. Database selection is the Architect's domain. Including this trains the stakeholder to think the PO decides technical architecture. The answer "PostgreSQL probably" would then appear in requirements, pre-empting the Architect's decision. -->

2. Should we use React or Vue for the frontend?
   **Answer:** React I guess.

<!-- PROBLEMA: Another technology question. "React or Vue" is a frontend framework decision that belongs to the Architect (and is constrained by the Golden Model, not the stakeholder). Asking this also produces a meaningless answer ("I guess") because the stakeholder is not a technical decision-maker. -->

3. What do you want the system to do?
   **Answer:** Everything for project management.

<!-- PROBLEMA: "What do you want the system to do?" is too vague to produce actionable requirements. "Everything for project management" is not a usable answer. Good questions are specific and answerable with a concrete value, yes/no, or a defined list. This question generates noise, not signal. -->

4. Is security important?
   **Answer:** Yes of course.

<!-- PROBLEMA: "Is security important?" is a leading question with a trivially "yes" answer for any project. It generates no actionable requirement. A good security question would be: "Are there roles with different access levels, and if so, what can each role see or do?" or "Is this system accessible from outside the corporate network?" -->

---

### Summary

All questions asked. Requirements are clear. Ready to write PRD.

<!-- PROBLEMA: No categorization. Questions are not grouped by area.
     PROBLEMA: "Requirements are clear" after these 4 questions is impossible. Budget, users, scope, business rules, retention, integrations — none of these were covered.
     PROBLEMA: "Ready to write PRD" with 4 inadequate questions and no business context answers is false. The PRD would be empty or fiction.
     PROBLEMA: No action items generated. No BR-NNN. No OQ-NNN. No NFR candidates. No scope decisions. -->

---

## Violations Summary

1. Technology questions asked (database, frontend framework) — not PO domain
2. Questions too vague to produce actionable answers ("what do you want?", "is security important?")
3. No questions about: business problem, target users, scope boundaries, business rules, data, risks
4. No categorization — all 4 questions are uncategorized
5. No action items: no BR-NNN, no OQ-NNN, no NFR candidates, no scope decisions
6. Session summary claims readiness that is not justified by the session content
7. Open_Questions.md not produced — all unanswered areas were silently ignored
