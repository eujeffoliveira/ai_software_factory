# rollback-planning-skill Checklist

## Pre-Execution
- [ ] Feature name provided
- [ ] Previous production deployment ID available (or noted as TBD if first deploy)
- [ ] Migration plan assessed (are there pending migrations?)

## Execution
- [ ] Rollback trigger conditions defined (minimum 4: healthcheck, error rate, smoke, manual)
- [ ] Application rollback steps written with specific Vercel dashboard actions
- [ ] Target deployment ID recorded
- [ ] Database rollback strategy documented (forward-fix or N/A)
- [ ] Post-rollback validation steps defined
- [ ] Estimated rollback time calculated (app + DB + validation)
- [ ] Rollback owner identified (specific role)
- [ ] Tech Lead notification channel documented

## Post-Execution
- [ ] `Rollback_Plan.md` produced from template
- [ ] All required sections complete (no TBD)
- [ ] Procedure verified in staging (or noted as blocking if not yet tested)
- [ ] `plan_status` set to COMPLETE

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 8. Cards: 009. Rules: DR001. Principles: P8.
