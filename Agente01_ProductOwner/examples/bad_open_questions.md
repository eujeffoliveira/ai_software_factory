# Bad Open Questions — Problems Annotated

_Four poorly formed open questions demonstrating common defects. Each problem is annotated._

---

## Open Questions (WRONG FORMAT)

---

### BAD-OQ-1 — Missing Criticality and Owner

**Question:** Should we add SMS support?

<!-- PROBLEMA: Sem ID no formato OQ-NNN. "BAD-OQ-1" não é um ID válido. Impossível referenciar esse item em outros artefatos (como "AC-001 depends on BAD-OQ-1" não é rastreável).
     PROBLEMA: Sem criticality — não é possível saber se bloqueia o PRD ou não. Sem criticidade, o Tech Lead não sabe se deve escalar ou aguardar.
     PROBLEMA: Sem impact — "should we add SMS" não explica o que muda no PRD se a resposta for sim ou não.
     PROBLEMA: Sem owner — quem responde essa pergunta? Nenhum stakeholder identificado.
     PROBLEMA: Sem deadline — question pode ficar aberta indefinidamente sem nenhum mecanismo de resolução. -->

---

### BAD-OQ-2 — Criticality Assigned Without Justification (Should be BLOCKING, labeled LOW)

| ID | Question | Impact | Criticality | Owner | Status |
|---|---|---|---|---|---|
| OQ-002 | Does the cancellation rule have exceptions? | Some | LOW | TBD | Open |

<!-- PROBLEMA: "Some" is not an impact description. What artifact changes? What story is affected? What decision cannot be made without this answer?
     PROBLEMA: Criticality is LOW, but this question determines whether BR-001 is final. If exceptions exist, a new story is needed and AC-003 must be revised. The PRD cannot be finalized without this answer — it should be BLOCKING.
     PROBLEMA: Owner is "TBD" — not an owner. A question without an owner has no path to resolution. It will stay open until someone takes ownership, which may never happen before Gate 1.
     PROBLEMA: The combination of LOW criticality + "TBD" owner means this question will be silently ignored, but it is actually the most critical question in this example register. -->

---

### BAD-OQ-3 — Technical Question That Belongs to the Architect

| ID | Question | Impact | Criticality | Owner | Status |
|---|---|---|---|---|---|
| OQ-003 | Should we use WebSockets or polling to update the staff schedule in real time? | Architecture decision | MEDIUM | Tech Lead | Open |

<!-- PROBLEMA: This is not a product open question — it is an architecture/implementation decision. The Product Owner's requirement is "the schedule view shows current data" (which becomes a functional requirement or NFR). The mechanism (WebSockets vs polling) is the Architect's domain.
     PROBLEMA: Including technical implementation questions in the PRD open questions register pollutes the product requirements with engineering decisions. The Architect would correctly ignore or redirect this.
     PROBLEMA: Owner is Tech Lead — correct person, but the question itself should not be in this register. Remove it from Open_Questions.md and add it to the Architect briefing as a design consideration.
     NOTA: If there is a business requirement for real-time updates (e.g., "staff must see new bookings within 10 seconds"), that requirement goes in the NFRs as NFR-OBS-NNN, not as an open question about the implementation. -->

---

### BAD-OQ-4 — Vague Question Without Actionable Outcome

| ID | Question | Impact | Criticality | Owner | Status |
|---|---|---|---|---|---|
| OQ-004 | Should the UX be good? | UX design | HIGH | Design team | Open |

<!-- PROBLEMA: "Should the UX be good?" is not a question — it is a trivially true statement. Every product should have good UX. This question has no actionable answer: "yes" or "no" both change nothing.
     PROBLEMA: A genuine open question has two possible answers that each lead to a different artifact decision. "Should UX be good?" has no such branching outcome.
     PROBLEMA: "UX design" is not an impact description. What artifact changes? What standard or process is triggered?
     PROBLEMA: HIGH criticality is unjustified given the vague question. No artifact can be blocked by a question this vague.
     PROBLEMA: "Design team" may not exist in this project context. Owner should be a specific role identifiable in the project roster.
     
     What a legitimate UX-related question would look like:
     OQ-004 | Does the public booking interface need to support screen readers and keyboard-only navigation (WCAG 2.1 AA), or is basic browser accessibility sufficient for v1? | Affects NFR-ACC-001 scope and the accessibility acceptance criterion for US-001. | HIGH | Product Manager | 2026-05-24 | Open -->
