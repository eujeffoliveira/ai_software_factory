# environment-validation-skill Checklist

## Pre-Execution
- [ ] `lib/env.ts` content available
- [ ] Staging variable name list available
- [ ] Production variable name list available

## Execution
- [ ] Zod schema variables extracted from `lib/env.ts`
- [ ] Staging: each variable checked for presence
- [ ] Production: each variable checked for presence
- [ ] Environment isolation checked (no shared secrets)
- [ ] Scattered `process.env` scan performed

## Post-Execution
- [ ] `overall_status` set correctly
- [ ] `Environment_Checklist.md` produced
- [ ] CRITICAL_FAIL escalation documented if shared secrets found

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 4. Cards: 005. Rules: DR003, DR008.
