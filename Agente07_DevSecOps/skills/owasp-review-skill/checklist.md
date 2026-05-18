# OWASP Review Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/checklists/owasp_top_10_checklist.md` and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 002) before executing. Do NOT access `context/` or `lib/`.

## Pre-execution
- [ ] All implementation files are available
- [ ] Results from parallel skills (secrets, authz, dependency, logging) are available
- [ ] Threat_Model.md status known (for A04)

## Per-Category Checks
- [ ] A01 Broken Access Control — auth check, IDOR, userId source, cron guard
- [ ] A02 Cryptographic Failures — secrets in code, HTTPS, env var pattern
- [ ] A03 Injection — Prisma parameterized, Zod validation, no raw SQL
- [ ] A04 Insecure Design — threat model exists and complete
- [ ] A05 Security Misconfiguration — no debug mode, no default creds, guardCron
- [ ] A06 Vulnerable Components — CVSS assessment from dependency scan
- [ ] A07 Authentication Failures — NextAuth v5, session validated per-route
- [ ] A08 Software Integrity — Vercel deploy, no untrusted CDN, migrate deploy
- [ ] A09 Logging Failures — audit_log present, no PII in logs
- [ ] A10 SSRF — no user-controlled URLs in fetch()

## Output Validation
- [ ] Exactly 10 rows in category_results
- [ ] Every PASS has evidence notes
- [ ] Every FAIL has finding_id, location, description, decision_rule
- [ ] findings array populated for all FAIL categories
