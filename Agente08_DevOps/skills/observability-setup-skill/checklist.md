# observability-setup-skill Checklist

## Pre-Execution
- [ ] Server Action files available for audit_log verification
- [ ] Cron handler files available for sync_log verification

## Execution
- [ ] audit_log: calls present in Server Actions, format correct, actorId from session
- [ ] sync_log: calls in finally block of all cron handlers (or N/A)
- [ ] Error tracking: DSN configured, test event verified
- [ ] Uptime monitoring: active on /api/healthcheck with alert channel
- [ ] Performance monitoring: Vercel Analytics enabled

## Post-Execution
- [ ] `overall_status` set: ALL_CONFIGURED or GAPS_FOUND
- [ ] Missing components listed in `gaps`
- [ ] Observability section of Deployment_Plan.md completed

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 9. Cards: 010.
