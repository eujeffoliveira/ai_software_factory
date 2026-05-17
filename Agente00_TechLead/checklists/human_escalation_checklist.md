# Human Escalation Checklist

Run this checklist when deciding whether to escalate to a human. If any item is checked, escalation is mandatory.

---

## Scope and Business Decisions

- [ ] User or agent has requested a scope change
- [ ] A feature conflicts with the approved PRD scope
- [ ] A business rule or priority cannot be determined from existing documentation
- [ ] A trade-off between business value and technical cost must be decided

---

## Financial Decisions

- [ ] A new paid external service is being introduced
- [ ] Infrastructure cost will increase significantly
- [ ] A pricing model change is required
- [ ] A licensing cost is being introduced

---

## Production Operations

- [ ] A deployment to the production environment is planned
- [ ] A production rollback is needed
- [ ] A destructive database migration is planned for production
- [ ] A production incident has been opened

---

## Security and Compliance

- [ ] A critical security risk has been found (BLOCKED_SECURITY_RISK)
- [ ] A critical data protection compliance risk has been found (BLOCKED_PRIVACY_RISK)
- [ ] A security exception must be accepted
- [ ] A data retention or deletion policy must be decided
- [ ] PII exposure risk cannot be mitigated without business decision

---

## Architectural Exceptions

- [ ] A Golden Path deviation is proposed and the Tech Lead cannot approve it unilaterally
- [ ] A decision involves irreversible structural change
- [ ] An ADR has been rejected and the agent insists on the deviation

---

## Inter-Agent Conflicts

- [ ] Two agents have produced contradictory artifacts and the conflict cannot be resolved by architecture
- [ ] Council Verdict recommended human decision

---

## Escalation Preparation

Before sending the escalation:

- [ ] `Human_Escalation_Request.md` is prepared using the template
- [ ] Urgency level is set (CRITICAL / HIGH / MEDIUM)
- [ ] Options are clearly presented (2–4 options)
- [ ] Risks per option are documented
- [ ] Tech Lead recommendation is included
- [ ] Impact of delay is stated
- [ ] Pipeline is formally blocked
- [ ] State Ledger updated: human_approvals_required += [this item]
