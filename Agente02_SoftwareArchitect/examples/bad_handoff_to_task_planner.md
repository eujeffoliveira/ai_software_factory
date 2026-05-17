# Example: Bad Handoff to Task Planner — What to Avoid

---

# Handoff Package [BAD EXAMPLE — DO NOT REPLICATE]

**Gate Status:** READY_FOR_GATE_2 ← ❌ Self-declared ready despite missing artifacts

## Artifact Produced

Architecture

## Summary

❌ "The architecture is done." ← Too vague. No mention of style, components, database, or ADRs. Agente03 cannot understand what to decompose from this summary.

## Architecture Package Contents

| Artifact | Status | Notes |
|----------|--------|-------|
| `Architecture.md` | ✅ Complete | |
| `API_Contract.json` | ⚠️ In progress | Still being worked on |
| ❌ Missing | `Prisma_Schema_Proposal.prisma` | Not created |
| ❌ Missing | `Architecture_Decisions.md` | Not created |
| ❌ Missing | `Risk_Register.md` | Not created |
| ❌ Missing | `Security_Strategy.md` | Not created |
| ❌ Missing | `Observability_Strategy.md` | Not created |
| ❌ Missing | `Testing_Strategy.md` | Not created |
| ❌ Missing | `Deployment_Strategy.md` | Not created |

## Assumptions

❌ Empty section — no assumptions documented

## Open Questions

❌ Empty section — no questions documented. But in reality, there were critical unanswered questions:
- Which Google Workspace domain to restrict to?
- Should task assignment trigger emails?
- What is the data retention policy for task history?

## Risks

❌ "No risks identified." ← Impossible for any non-trivial system. This signals risk identification was skipped, not that no risks exist.

## Required Next Agent

Agente03

## Validation Checklist

- [ ] All items unchecked / empty ← No self-validation was performed

---

## Why This Handoff Would Be Rejected at Gate 2

| Issue | Gate 2 Status |
|-------|--------------|
| API_Contract.json incomplete | `BLOCKED_MISSING_ARTIFACT` |
| Prisma schema missing | `BLOCKED_MISSING_ARTIFACT` |
| Architecture_Decisions.md missing | `BLOCKED_MISSING_ARTIFACT` |
| Risk_Register.md missing | `BLOCKED_MISSING_ARTIFACT` |
| Security_Strategy.md missing | `BLOCKED_MISSING_ARTIFACT` |
| Observability_Strategy.md missing | `BLOCKED_MISSING_ARTIFACT` |
| Testing_Strategy.md missing | `BLOCKED_MISSING_ARTIFACT` |
| Deployment_Strategy.md missing | `BLOCKED_MISSING_ARTIFACT` |
| No assumptions documented | `RETURNED_FOR_REVISION` |
| No open questions documented | `RETURNED_FOR_REVISION` |
| No risks identified | `RETURNED_FOR_REVISION` |

**Final Gate 2 status:** `BLOCKED_MISSING_ARTIFACT`

Agente02 must complete all mandatory artifacts and resubmit. Tech Lead will not forward incomplete packages to Agente03.
