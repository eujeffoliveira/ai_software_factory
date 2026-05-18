# Bad Rollback Plan Example

This example shows an inadequate Rollback_Plan.md that triggers `BLOCKED_NO_ROLLBACK_PLAN`. Do NOT produce plans like this.

---

# Rollback Plan
## Feature: Dashboard Update

---

## Rollback

If something goes wrong, we can roll back using Vercel.

For the database, we will handle it if needed.

Contact: someone on the team.

---

**WHAT IS WRONG WITH THIS EXAMPLE (do not make these mistakes):**

1. **Missing trigger conditions** — What condition causes rollback? This document does not say. Without explicit trigger conditions (healthcheck failure threshold, error rate threshold), the on-call engineer must guess when to act. This costs time during an incident and raises MTTR.

2. **"We can roll back using Vercel"** — This is not a procedure. The plan must name the specific Vercel dashboard path (Deployments tab), the specific previous deployment ID, and the exact UI action ("Promote to Production"). During an incident, engineers should not need to figure out how Vercel rollback works.

3. **No target deployment ID** — "previous deployment" is ambiguous if there are multiple recent deployments. The rollback plan must identify the specific deployment to roll back to (verified in staging).

4. **"We will handle it if needed" for database** — This is dangerous. If a destructive migration was applied and the database state needs to change, there must be a forward-fix migration prepared in advance. "Handle it if needed" means improvising under pressure with production data at risk.

5. **No estimated rollback time** — "Contact someone on the team" does not give engineers a recovery time estimate to communicate to users and stakeholders. MTTR estimation must be pre-calculated.

6. **No post-rollback validation** — Without defined validation steps, engineers do not know when rollback is "done" and service is restored.

7. **No rollback procedure verification in staging** — The plan does not say it was tested. DR001 requires the procedure to be verified in staging before production deployment.

8. **"Contact: someone on the team"** — The rollback owner must be a specific role (e.g., "Tech Lead (on-call)") with a defined contact channel, not an ambiguous "someone."

**Correct action:** Issue Gate 6 `BLOCKED_NO_ROLLBACK_PLAN`. Invoke `rollback-planning-skill` to produce a complete plan following the structure in `templates/Rollback_Plan.md`. Test the procedure in staging. Do not issue `READY_FOR_HUMAN_APPROVAL` until all required sections are complete.
