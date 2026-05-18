# Bad Output — rollback-planning-skill

**Plan Status:** COMPLETE ❌ WRONG — missing sections

**Rollback_Plan.md produced with:**
- Trigger: "if something breaks"
- Rollback steps: "use Vercel to rollback"
- DB rollback: TBD
- Owner: someone on the team
- Tested in staging: NO

**WHAT IS WRONG:**
- "If something breaks" is not a trigger condition — specific metrics required
- "Use Vercel to rollback" is not a procedure — specific UI steps required
- "TBD" DB rollback = plan is INCOMPLETE (DR001 blocks Gate 6)
- "Someone on the team" is not a rollback owner — specific role required
- Not tested in staging = BLOCKS Gate 6 (rollback must be verified)
