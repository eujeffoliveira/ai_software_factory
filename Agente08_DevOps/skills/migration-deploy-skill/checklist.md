# migration-deploy-skill Checklist

## Pre-Execution
- [ ] `prisma migrate status` output reviewed
- [ ] No `prisma db push` evidence found in target environment
- [ ] All pending migration files have SQL content available

## Execution
- [ ] Each migration SQL reviewed and classified (CREATE/ALTER/DROP/etc.)
- [ ] `is_destructive` assessed for each migration
- [ ] Duration estimated per migration using row count + operation type
- [ ] Backward compatibility assessed
- [ ] Human sign-off required flagged for destructive migrations
- [ ] Forward-fix rollback migration described

## Post-Execution
- [ ] `Migration_Deploy_Plan.md` produced
- [ ] `execution_readiness` set correctly
- [ ] All destructive migrations have documented sign-off requirement

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 5. Cards: 003. Rules: DR002, DR004, DR011.
