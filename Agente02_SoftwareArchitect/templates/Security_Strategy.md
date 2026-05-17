# Security Strategy — [Project Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Architect:** Agente02_SoftwareArchitect

---

## 1. Authentication

**Provider:** Google OAuth  
**Library:** NextAuth v5  
**Domain restriction:** [Yes — restricted to @domain.com | No — open to all Google accounts]  
**Session strategy:** [JWT | Database]  
**User status model:** `pending` → `approved` | `rejected`  
**Session invalidation:** Sessions are invalidated when user status changes to `rejected`.

---

## 2. Authorization Model

**Type:** [RBAC — Role-Based Access Control]  
**Enforcement layer:** Server-side only — never trust client-side checks.

**Roles:**
| Role | Description | Permissions |
|------|-------------|-------------|
| `admin` | Full system access | All operations |
| `user` | Standard user | Own data only |

**Authorization check pattern (Server Action):**
```ts
const session = await auth();
if (!session?.user) throw new Error("Unauthorized");
if (session.user.status !== "approved") throw new Error("Forbidden");
if (session.user.role !== "admin") throw new Error("Forbidden");
```

---

## 3. Data Classification

| Category | Examples in This Project | Handling Rules |
|----------|--------------------------|----------------|
| PII | Email, name, phone | Never log plain text; mask in exports; subject to retention policy |
| Sensitive PII | [if applicable] | Same as PII + explicit consent required |
| Financial | [if applicable] | Restricted access; audit_log for all reads and writes |
| Operational | Timestamps, statuses, counts | Standard handling |
| Technical | IDs, config flags | Standard handling |
| Public | Published content | No restrictions |

---

## 4. Threat Model

### 4.1. Threat Modeling Questions (per endpoint)

For each endpoint in `API_Contract.json`, answer:

1. **Who can call this?** (authenticated user, admin, cron, anonymous)
2. **What happens if anonymous calls?** (401 response, no data exposure)
3. **What happens if authenticated but unauthorized user calls?** (403 response)
4. **What sensitive data passes through here?** (list PII fields)
5. **OWASP Top 10 risks?** (injection, XSS, CSRF, Broken Auth, etc.)

### 4.2. Endpoint Threat Model

| Endpoint | Callers | Anon Call | Unauth Call | PII Exposure | OWASP Risks | Mitigations |
|----------|---------|-----------|-------------|--------------|-------------|-------------|
| `POST /api/actions (via Server Action)` | Approved users | 401 | 403 | [list] | CSRF, Broken Auth | NextAuth session, server-side auth check |
| `GET /api/health` | Anyone | Returns status only | N/A | None | None | No sensitive data in response |
| `GET /api/cron/[job]` | Vercel Cron | 401 | 401 | None | Broken Auth | guardCron() with CRON_SECRET |

---

## 5. Env Variables Classification

| Variable | Sensitivity | Validation in lib/env.ts |
|----------|-------------|--------------------------|
| `DATABASE_URL` | secret | `z.string().min(10)` |
| `NEXTAUTH_SECRET` | secret | `z.string().min(32)` |
| `GOOGLE_CLIENT_ID` | secret | `z.string().min(1)` |
| `GOOGLE_CLIENT_SECRET` | secret | `z.string().min(1)` |
| `CRON_SECRET` | secret | `z.string().min(16)` |
| `NEXT_PUBLIC_APP_URL` | config | `z.string().url()` |

---

## 6. Audit Logging Strategy

### audit_log (human actions)

The following actions must write to `audit_log`:

- [ ] User account approval/rejection
- [ ] Role change
- [ ] Manual job execution
- [ ] Data export
- [ ] Configuration change
- [ ] [Domain-specific sensitive actions]

### sync_log (automated jobs)

The following jobs must write to `sync_log`:

- [ ] [Cron job name] — fields: job, executed_at, duration_ms, status, counts, error_msg

---

## 7. Data Protection Compliance

| Requirement | Implementation |
|-------------|---------------|
| Data minimization | Only collect fields required for the business use case |
| Right to deletion | User data deletion implemented in `lib/db/user.ts` |
| Data retention | [Retention period] — automated cleanup job if applicable |
| Logs | No PII in plain text logs |
| Exports | Restricted to admin role; audit_log entry created |

---

## 8. Known Security Risks

| RISK-ID | Classification | Description | Mitigation |
|---------|---------------|-------------|------------|
| RISK-001 | [HIGH/MEDIUM] | [Risk description] | [Mitigation] |

---

## 9. DevSecOps Review Points

The following components must be reviewed by DevSecOps (Agente07) before Gate 5:

- [ ] proxy.ts configuration
- [ ] auth.ts callbacks and domain restriction
- [ ] lib/env.ts validation completeness
- [ ] All Server Actions with auth check
- [ ] All public API endpoints
- [ ] Models containing PII fields
- [ ] Audit log coverage
- [ ] Dependency security scan
