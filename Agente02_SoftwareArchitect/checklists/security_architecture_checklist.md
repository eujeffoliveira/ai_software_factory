# Security Architecture Checklist

_Run `security-architecture-skill` using this checklist._

---

## Authentication

- [ ] Auth library is NextAuth v5 (or ADR for alternative)
- [ ] Provider is Google OAuth (or ADR for alternative)
- [ ] Domain restriction is configured in signIn callback
- [ ] User status lifecycle (pending → approved | rejected) is in the data model
- [ ] Sessions are invalidated when user status changes to rejected
- [ ] Session strategy (JWT or database) is documented

## Authorization

- [ ] All authorization checks are server-side
- [ ] No endpoint relies on client-side-only access control
- [ ] Role is stored in the database (not only in JWT)
- [ ] Every protected Server Action checks: auth(), role, and status
- [ ] Every protected Route Handler checks: auth(), role, and status

## Threat Model

For every endpoint in API_Contract.json:
- [ ] Q1 answered: Who can call this endpoint?
- [ ] Q2 answered: What happens if anonymous calls?
- [ ] Q3 answered: What happens if authenticated but unauthorized calls?
- [ ] Q4 answered: What sensitive data passes through here?
- [ ] Q5 answered: OWASP Top 10 risks assessed (SQLi, XSS, SSRF, CSRF, Broken Auth)?

## Data Classification

- [ ] All data categories are classified (PII, sensitive PII, operational, financial, integration, public)
- [ ] PII fields are listed per model
- [ ] Log design ensures no PII is logged in plain text
- [ ] Export operations are restricted and audited
- [ ] Data retention policy is defined

## Secrets and Environment Variables

- [ ] All secrets validated in lib/env.ts
- [ ] No hardcoded secrets in any template or example
- [ ] NEXTAUTH_SECRET has minimum length validation (≥ 32 chars)
- [ ] CRON_SECRET has minimum length validation (≥ 16 chars)
- [ ] DATABASE_URL is validated as string (connection string format)

## Audit and Compliance

- [ ] audit_log instrumentation points are identified for all sensitive human actions
- [ ] sync_log instrumentation points are identified for all automated jobs
- [ ] Sensitive data access is logged (at minimum, export operations)
- [ ] Data deletion mechanism is identified if right-to-erasure applies

## Infrastructure

- [ ] proxy.ts is the first line of defense (session verification at edge)
- [ ] All cron routes use guardCron()
- [ ] Stack trace is never exposed to clients
- [ ] Error responses use generic messages for internal errors

## DevSecOps Handoff Points

- [ ] Security_Strategy.md is complete and ready for DevSecOps review (Gate 5)
- [ ] All CRITICAL security risks are escalated (not self-accepted)
- [ ] Threat model covers all endpoints
