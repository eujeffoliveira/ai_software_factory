# Council Activation Checklist

Run this checklist when deciding whether to trigger the Tech Lead Council.

---

## Mandatory Triggers (activate Council immediately)

- [ ] Architecture approval involves a significant Golden Path deviation
- [ ] Production database schema change is proposed
- [ ] Destructive migration is planned
- [ ] Security risk acceptance is being considered
- [ ] Go-live decision for a critical system
- [ ] Critical production incident with unclear root cause or remedy
- [ ] Inter-agent conflict that cannot be resolved by existing architecture decisions

---

## Recommended Triggers (consider Council for better outcomes)

- [ ] PRD approval for a feature with high business complexity
- [ ] Architecture involves trade-offs between performance, cost, and maintainability
- [ ] New external service integration with significant supply chain or compliance risk
- [ ] Tech Lead is uncertain about the right path and multiple options have significant merit
- [ ] A decision will affect the system for more than 1 year

---

## Pre-Council Preparation

Before activating the Council:

- [ ] Topic is clearly defined (not vague)
- [ ] Relevant artifacts are available (PRD, Architecture, Risk Register)
- [ ] Context is concise (< 500 words summary)
- [ ] At least two concrete options exist to evaluate
- [ ] Constraints are known (cost, time, compliance, architecture rules)

---

## Council Execution

- [ ] Contrarian persona analysis completed
- [ ] First Principles Thinker analysis completed
- [ ] Expansionist analysis completed
- [ ] Outsider analysis completed
- [ ] Executor analysis completed
- [ ] Consensus points identified
- [ ] Clash points identified
- [ ] Blind spots identified
- [ ] Recommendation synthesized
- [ ] "One thing to do first" stated

---

## Post-Council

- [ ] `Council_Verdict.md` produced using template
- [ ] State Ledger updated with Council activation and verdict
- [ ] If Council recommends human decision: `Human_Escalation_Request.md` prepared
- [ ] Gate decision incorporates Council verdict
