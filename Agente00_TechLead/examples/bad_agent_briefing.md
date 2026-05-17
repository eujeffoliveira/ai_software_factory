# Bad Agent Briefing — Agente02_SoftwareArchitect

_BAD EXAMPLE — Multiple violations. Do not use as a model._

**Violations:**
- No phase specified
- No gate target specified
- Task description is vague — "design the system"
- Inputs not listed — agent doesn't know what's available
- No constraints specified — agent has no guardrails
- No Golden Model reminders — agent may deviate freely
- No open questions addressed
- No risks to consider
- No escalation policy
- Expected outputs not specified
- No mention of Handoff Package requirement

---

## Task

Design the system. Make it work. Use whatever makes sense. The PRD is ready, just read it and figure out the right approach. We need something by end of week.

---

## Notes

Make sure the database is flexible and the API is clean. We might add more features later so design for scale. Use whatever framework the team prefers.

---

_This briefing will lead to:_
- _Architecture that ignores the Golden Model_
- _No ADRs for deviations_
- _Incomplete artifacts (missing API_Contract, DB_Schema)_
- _No security considerations_
- _No handoff package_
- _Gate 2 will fail_
