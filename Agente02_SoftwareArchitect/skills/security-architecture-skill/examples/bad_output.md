# Bad Output — security-architecture-skill

## Scenario

Same job board SaaS. DELETE /api/jobs/{id} is one of the endpoints to analyze.

## Produced Security_Strategy.md (problematic excerpt)

```
## Security

Authentication: We use NextAuth.

Data: User data is sensitive.

## Endpoint Security

POST /api/jobs: requires login
GET /api/jobs: public
DELETE /api/jobs/{id}: requires login, risk accepted

## Risk accepted: All risks are LOW. No escalation needed.
```

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | "We use NextAuth" — no session storage, token lifetime, or sign-out behavior documented | Auth strategy must document: storage (httpOnly cookies), token lifetime, sign-out behavior |
| 2 | "User data is sensitive" — no data classification table | Every entity and field must be classified: PUBLIC/INTERNAL/CONFIDENTIAL/PII/PII_SENSITIVE |
| 3 | Threat modeling for POST /api/jobs: only "requires login" — no 5-question analysis | All 5 threat modeling questions required per endpoint |
| 4 | GET /api/jobs listed as "public" — no analysis of what data is exposed to unauthenticated users | Q2 (data exfiltration risk) and Q3 (malformed input) must be analyzed |
| 5 | DELETE /api/jobs/{id}: "risk accepted" — CRITICAL risk self-closed without analysis | CRITICAL risks cannot be self-accepted; requires human escalation and Risk_Register.md entry |
| 6 | "All risks are LOW" — blanket classification with no evidence | Each endpoint must receive an individual threat level based on Q1–Q5 answers |
| 7 | No RBAC matrix defined | Role × resource × operation matrix required |
| 8 | Ownership check for DELETE not mentioned | Ownership enforcement point (Server Action, server-side) must be documented |
| 9 | No rate limiting defined for any endpoint | Rate limiting required for unauthenticated and mutation endpoints |
| 10 | No CORS policy, no CSP headers, no Zod validation confirmation | Security controls section missing entirely |
| 11 | No `audit_log` requirements produced for `observability-design-skill` | Security strategy must feed audit_log event requirements downstream |

## Gate result

`BLOCKED_PENDING_SECURITY` — Security_Strategy.md fails quality gate on 11 dimensions. The self-accepted risk on DELETE /api/jobs/{id} (which is CRITICAL) is a hard block: Gate 5 remains blocked until the Tech Lead reviews the ownership bypass risk. Skill must rerun with full threat modeling per endpoint and all sections populated.
