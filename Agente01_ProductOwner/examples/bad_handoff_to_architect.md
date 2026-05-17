# Handoff Package — Gate 1 (PRD to Architecture)

_BAD EXAMPLE — Multiple violations. Do not use as a model._

---

**From:** Product Owner
**To:** Architect
**Gate Target:** Gate 1
**Date:** 2026-05-17

---

## artifact_produced

PRD is ready.

<!-- PROBLEMA: "PRD is ready" is not an artifact reference. The field should list the exact filename (PRD.md v1.0) plus all supporting artifacts produced. Here, 7 supporting artifacts are silently omitted. The Tech Lead cannot verify completeness without knowing what was produced. -->

---

## summary

The PRD covers the scheduling system. All requirements have been gathered and the document is complete.

<!-- PROBLEMA: Summary is 2 sentences — the minimum is 3 substantive sentences. More importantly, these 2 sentences contain no information: "requirements have been gathered" does not describe what was decided, what was discovered during elicitation, what constraints were found, or what assumptions were made. This is boilerplate, not a summary.
     PROBLEMA: No mention of open questions that were resolved or remain open.
     PROBLEMA: No mention of notable constraints discovered during elicitation.
     PROBLEMA: No mention of key decisions made during requirements gathering. -->

---

## assumptions

(none)

<!-- PROBLEMA: An empty assumptions list is almost always wrong. Every PRD makes assumptions — deployment model, user device capabilities, account model, etc. An empty list means the Product Owner did not identify assumptions, which is either incorrect or means unacknowledged assumptions will surprise the Architect.
     PROBLEMA: If there are truly no assumptions, the list should contain at least "No assumptions were made — all constraints were explicitly confirmed by stakeholders" with supporting evidence. -->

---

## open_questions

(none)

<!-- PROBLEMA: An empty open_questions list immediately after the requirements phase is a strong signal of a problem. Either (a) all questions were resolved — which should be documented with resolutions — or (b) open questions exist but were not registered. In this example, OQ-001, OQ-003, and OQ-004 are known open questions that the Product Owner silently omitted.
     PROBLEMA: The Architect will proceed assuming no open questions exist and make design decisions based on that assumption. When OQ-001 is later answered (SMS required), the notification architecture may need to be redesigned. -->

---

## risks

(none)

<!-- PROBLEMA: "None" in the risks field means the Product Owner assessed the product and found no risks. This is almost never true. In this example, PRISK-001 (low adoption risk) and PRISK-002 (email deliverability) are known risks that were identified during elicitation but not reported here.
     PROBLEMA: The Architect and Tech Lead cannot factor risks into the architecture design if they are not surfaced. Omitting risks from the handoff is a quality defect. -->

---

## required_next_agent

Software Developer

<!-- PROBLEMA: "Software Developer" is not a valid agent ID. The valid ID is Agente02_SoftwareArchitect for the next phase — and the immediate next agent should be Agente00_TechLead for Gate 1 review, not a developer. Skipping the gate and routing directly to a developer would bypass the governance process entirely. -->

---

## suggested_following_agent

(not specified)

<!-- PROBLEMA: suggested_following_agent is omitted. This field guides the Tech Lead on which agent should receive the briefing after Gate 1 approval. Without it, the Tech Lead must infer the routing, which introduces error risk. -->

---

## validation_checklist

(empty)

<!-- PROBLEMA: An empty validation checklist means the Product Owner submitted the handoff without verifying any of the gate criteria. This is a hard Gate 1 blocker — the Tech Lead will return this handoff immediately.
     PROBLEMA: The validation checklist exists to give the Tech Lead confidence that the Product Owner self-verified the package. "Trust me, it's complete" is not a substitute for a completed checklist. -->

---

## Violations Summary

1. `artifact_produced` — vague, does not list supporting artifacts
2. `summary` — 2 boilerplate sentences; no decisions, constraints, or discoveries described
3. `assumptions` — empty; real assumptions were made but not documented
4. `open_questions` — empty; 3 known open questions were silently omitted
5. `risks` — empty; 2 identified product risks were not reported
6. `required_next_agent` — invalid agent ID; routes to wrong agent, skips gate
7. `suggested_following_agent` — omitted entirely
8. `validation_checklist` — empty; self-verification was not performed

**Consequence:** This handoff will be returned by Agente00_TechLead with status `RETURNED_FOR_REVISION`. No gate decision can proceed until all 8 issues are corrected.
