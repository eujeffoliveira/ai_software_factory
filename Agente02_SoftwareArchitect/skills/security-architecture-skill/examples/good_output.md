# Good Output — security-architecture-skill

## Scenario

Job board SaaS. Endpoints: POST /api/jobs, GET /api/jobs, DELETE /api/jobs/{id}, GET /api/health. Two roles: RECRUITER (creates/manages jobs) and CANDIDATE (applies to jobs). User.email and User.name are PII.

## Security_Strategy.md (excerpt)

---

## Data Classification

| Entity | Field | Classification |
|--------|-------|----------------|
| User | email | PII |
| User | name | PII |
| User | role | INTERNAL |
| Company | name | INTERNAL |
| Company | slug | PUBLIC |
| Job | title | PUBLIC (when published) |
| Job | description | PUBLIC (when published) |
| JobApplication | status | CONFIDENTIAL |

---

## Authentication Strategy

- Provider: NextAuth v5 + Google OAuth
- Session storage: **httpOnly cookie only** — `next-auth.session-token` — never stored in localStorage or sessionStorage
- Token lifetime: 30 days (configurable via `NEXTAUTH_SESSION_MAX_AGE` in `lib/env.ts`)
- Sign-out: `signOut()` server action invalidates session server-side and clears cookie
- Public (unauthenticated) routes:
  - `GET /api/health` — liveness check, explicitly public
  - `GET /` — landing page

---

## RBAC Matrix

| Role | Job (read) | Job (create) | Job (update) | Job (delete) | Application (read own) | Application (read all for job) |
|------|-----------|-------------|-------------|-------------|----------------------|-------------------------------|
| RECRUITER | Own company only | Own company | Own company | Own company | No | Yes (own jobs only) |
| CANDIDATE | Published only | No | No | No | Yes (own) | No |

**Ownership enforcement:** `deleteJob()` Server Action checks `job.companyId === session.user.companyId` server-side before executing DELETE. This check is NOT in the route handler and NOT client-side.

---

## Threat Modeling

### POST /api/jobs

| Question | Answer |
|----------|--------|
| Q1: Who can call this? | Authenticated RECRUITER only |
| Q2: Response data exfiltration? | Returns created Job (INTERNAL) — no PII exposed |
| Q3: Malformed input risk? | Zod schema validates body — invalid input returns 400 with no internal error details |
| Q4: Blast radius if compromised? | Attacker could create fake job listings — HIGH reputational risk |
| Q5: Audit trail? | `job_created` audit_log event with userId, companyId, jobId |

**Threat level: HIGH**  
**Controls: Zod validation, RECRUITER auth check, rate limit 20 req/min per userId, audit_log**

### DELETE /api/jobs/{id}

| Question | Answer |
|----------|--------|
| Q1: Who can call this? | Authenticated RECRUITER, owns the job |
| Q2: Response data exfiltration? | Returns `{ success: true }` only |
| Q3: Malformed input risk? | Path param is a cuid — invalid format returns 400 |
| Q4: Blast radius if compromised? | Could delete competitor's jobs if ownership check bypassed — CRITICAL |
| Q5: Audit trail? | `job_deleted` audit_log event |

**Threat level: CRITICAL**  
**Risk: RISK-015 — Ownership bypass on DELETE /api/jobs/{id}**  
**Mitigation: Server-side ownership check in `deleteJob()` Server Action. ESCALATED TO TECH LEAD.**

---

## Security Controls Summary

| Control | Applied to |
|---------|-----------|
| Rate limit: 20 req/min per userId | POST /api/jobs |
| Rate limit: 5 req/min per IP | POST /api/auth/* (auth endpoints) |
| Zod validation | All POST/PATCH endpoints |
| httpOnly cookies | All session tokens |
| CORS: only `https://app.domain.com` | All authenticated endpoints |
| CSP headers via next.config.ts | All pages |

---

## Why this is a good output

- All 5 threat modeling questions answered for every endpoint
- CRITICAL risk (ownership bypass on DELETE) written to Risk_Register.md with `escalation_required: true`
- Skill does NOT self-approve the CRITICAL risk — it escalates
- Data classification table covers all entities and fields
- Session storage explicitly documented as httpOnly cookie (not localStorage)
- RBAC matrix covers all role × resource × operation combinations
- Ownership enforcement point confirmed as Server Action (server-side)
- `auth_strategy_complete: true`, `pii_fields_classified: true`, `escalation_required: true`
