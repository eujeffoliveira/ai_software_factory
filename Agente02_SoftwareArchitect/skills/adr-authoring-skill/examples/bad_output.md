# Bad Output — adr-authoring-skill

## Scenario

Same scenario: AI-powered resume scoring feature requiring a Python service.

## Produced ADR (problematic)

**File:** `docs/adr/adr-python-service.md`

---

# Use Python for AI

**Status:** ACCEPTED

## Context

We need AI for scoring resumes. Python is better for this.

## Decision

Use Python/FastAPI.

## Alternatives

Only considered Python/FastAPI — it was the obvious choice.

## Consequences

Good performance.

---

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | Status is `ACCEPTED` — self-approved without Tech Lead review | Status must start as `PROPOSED` |
| 2 | Filename `adr-python-service.md` — missing ADR number and unclear title | Must follow `ADR-NNN-kebab-case-title.md` pattern |
| 3 | Context is 2 sentences with no problem description — says "Python is better" without explaining forcing function | Context must explain the forcing function (NFR, constraint) |
| 4 | Only 1 alternative documented — "the obvious choice" — no Golden Path default evaluated | Minimum 2 alternatives; Golden Path default must be explicitly considered and rejected |
| 5 | Consequences is a single vague phrase "Good performance" — no negative consequences listed | Must list at least 1 positive AND 1 negative consequence |
| 6 | No PRD requirement ID cited anywhere | Every ADR must trace to a PRD requirement |
| 7 | Decision does not start with "We will…" | Decision statement format required |

## Gate result

Gate 2 remains `BLOCKED_PENDING_ADR` — this ADR does not satisfy completeness criteria. Skill must rerun with full `decision_context` input.
