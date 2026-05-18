# Logging Privacy Review Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/checklists/logging_privacy_checklist.md` and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 010) before executing. Do NOT access `context/` or `lib/`.

## Log Call Discovery
- [ ] All audit_log.create() calls found across implementation files
- [ ] All sync_log write calls found
- [ ] All console.log/error/warn calls found in production code

## Per audit_log Call
- [ ] actorId: sourced from session.user.id (not request)
- [ ] actorEmail: sourced from session.user.email (not request, not input)
- [ ] action: string constant (not user-supplied)
- [ ] entityType: string constant
- [ ] entityId: internal ID (not user content)
- [ ] metadata: each key-value inspected — no raw PII values
- [ ] metadata: no passwords, tokens, or API keys

## Per sync_log Call
- [ ] No user email addresses or names
- [ ] No record-level PII (only counts, statuses, IDs)

## Per console.log/error Call
- [ ] No request body serialization (console.log(req.body))
- [ ] No user object serialization (console.log(user))
- [ ] No token or API key logging

## Output
- [ ] status: PASS if no PII found in any log field
- [ ] status: FAIL if any PII, password, or token found in log field
- [ ] findings populated with severity (CRITICAL for passwords/tokens, HIGH for raw PII)
- [ ] DR005 referenced for all log PII findings
