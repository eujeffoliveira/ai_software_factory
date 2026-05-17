# migration-risk-analysis-skill Checklist

## Pre-execution
- [ ] `Prisma_Schema_Proposal.prisma` or `DB_Schema.sql` is available and complete
- [ ] Current production/staging schema available for diff (or confirmed as "green field")
- [ ] Target environments confirmed: staging and/or production
- [ ] Zero-downtime requirement confirmed with Tech Lead or Deployment_Strategy.md
- [ ] `Risk_Register.md` path known (to append entries with next available RISK-NNN)

## During execution
- [ ] All schema changes enumerated individually (one per row in analysis table)
- [ ] Each change classified: REVERSIBLE, COMPATIBLE, IRREVERSIBLE, or DESTRUCTIVE
- [ ] Overall risk level derived from highest individual classification
- [ ] Every change has a rollback plan
  - [ ] REVERSIBLE: exact DROP statement written
  - [ ] COMPATIBLE: migration inverse written (even if it requires a new migration file)
  - [ ] IRREVERSIBLE: backup step + transformation inverse documented
  - [ ] DESTRUCTIVE: three-phase plan written
- [ ] `data_loss_on_rollback` set correctly for each step
- [ ] Zero-downtime eligibility assessed: only REVERSIBLE changes qualify without expand-contract pattern
- [ ] Migration command validated: `prisma migrate deploy` for staging/prod; `prisma db push` only for local
- [ ] RISK-NNN IDs assigned without collision with existing Risk_Register.md entries

## Post-execution
- [ ] `overall_risk_level` is the maximum of all individual step classifications
- [ ] `phased_plan_required: true` when any DESTRUCTIVE step present, and `phased_plan` is populated
- [ ] `migration_command_valid: true` confirmed
- [ ] All RISK-NNN entries appended to `Risk_Register.md`
- [ ] Migration execution plan section appended to `Deployment_Strategy.md`

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/`, `Agente02_SoftwareArchitect/context_view.md`, and project artifacts as input only
