# Agente07_DevSecOps — Context View

> Compiled local context for runtime use. This file replaces all `context/` sources at runtime. Do not read `context/` at runtime.
> Last compiled: 2026-05-17 | Version: 1.0.0

---

## 1. Agent Position in the Pipeline

```
Gate 4 (QA Review — Agente06_QaEngineer)
    │ APPROVED (QA_Report.md with gate_ready: true)
    ▼
Gate 5 (Security Review — Agente07_DevSecOps)  ← THIS AGENT
    │
    ├── BLOCKED/RETURNED → Agente04_DevBackend / Agente05_DevFrontend (with Remediation_Guide.md)
    │
    └── APPROVED → Gate 6 (Deployment Review — Agente08_DevOps)
```

**Critical rule**: Gate 5 cannot be bypassed. It cannot be overridden by the Tech Lead. Only this agent can issue a Gate 5 APPROVED.

---

## 2. STRIDE Threat Model Categories

STRIDE is the mandatory threat analysis framework for all features touching auth, authz, or sensitive data.

| Category | Threat | Common Vector in This Stack |
|----------|--------|-----------------------------|
| **S — Spoofing** | Impersonating another user or system | Auth bypass, session forgery, missing `auth()` check |
| **T — Tampering** | Modifying data without authorization | SQL injection, missing input validation, Prisma raw queries |
| **R — Repudiation** | Denying an action was taken | Missing `audit_log` for sensitive operations |
| **I — Information Disclosure** | Exposing data to unauthorized parties | Stack traces to client, PII in logs, secrets in code |
| **D — Denial of Service** | Degrading or halting service availability | Missing rate limiting, unbounded queries, resource exhaustion |
| **E — Elevation of Privilege** | Gaining higher access than authorized | IDOR, userId from request body, missing resource-level authz |

---

## 3. OWASP Top 10 (2021) — Audit Coverage Map

| ID | Category | Primary Check in This Stack |
|----|----------|-----------------------------|
| A01 | Broken Access Control | Auth check on every route; resource-level authz; no IDOR; `userId` from session only |
| A02 | Cryptographic Failures | Secrets via `lib/env.ts` only; HTTPS enforced; no plaintext sensitive storage |
| A03 | Injection | Prisma parameterized queries only; no raw SQL string concatenation; Zod input validation |
| A04 | Insecure Design | Threat model exists; trust boundaries defined; no business logic in route handlers |
| A05 | Security Misconfiguration | No default credentials; no debug mode in prod; `guardCron()` on all cron routes |
| A06 | Vulnerable Components | `package.json` dependency scan; CVSS thresholds applied |
| A07 | Auth Failures | NextAuth v5 pattern; `const session = await auth()` first; session not trusted from client |
| A08 | Software & Data Integrity | No untrusted CDN scripts; Vercel deployment integrity; `prisma migrate deploy` only |
| A09 | Security Logging Failures | `audit_log` for all sensitive actions; no PII in logs; structured JSON format |
| A10 | SSRF | External URL inputs validated; no user-controlled URL passed to `fetch()` without allowlist |

---

## 4. Golden Path Security Rules

### 4.1 Authentication Pattern (MANDATORY)
```typescript
// CORRECT — auth check is always FIRST operation
export async function someServerAction(input: unknown) {
  const session = await auth();
  if (!session) {
    return { error: "Unauthorized" }; // or throw new Error("Unauthorized")
  }
  // business logic only AFTER this point
}

// WRONG — business logic before auth check (CRITICAL finding)
export async function someServerAction(input: unknown) {
  const data = await prisma.record.findMany(); // DB access without auth!
  const session = await auth();
}
```

### 4.2 Resource-Level Authorization (MANDATORY)
```typescript
// CORRECT — check ownership before returning data
const record = await prisma.record.findFirst({
  where: { id: recordId, userId: session.user.id } // ownership check in query
});
if (!record) return { error: "Not found" };

// WRONG — no ownership check (IDOR — CRITICAL finding)
const record = await prisma.record.findUnique({ where: { id: recordId } });
// returns any user's record to any authenticated user
```

### 4.3 userId Source (MANDATORY)
```typescript
// CORRECT — userId always from session
const userId = session.user.id;

// WRONG — userId from request body (privilege escalation — CRITICAL finding)
const { userId } = await request.json(); // NEVER trust this
```

### 4.4 Secrets and Environment Variables (MANDATORY)
```typescript
// CORRECT — all env vars through lib/env.ts
import { env } from "@/lib/env";
const apiKey = env.EXTERNAL_API_KEY;

// WRONG — scattered process.env (MEDIUM finding)
const apiKey = process.env.EXTERNAL_API_KEY;

// WRONG — hardcoded secret (CRITICAL finding)
const apiKey = "sk-abc123xyz789...";
```

### 4.5 Database Queries (MANDATORY)
```typescript
// CORRECT — Prisma parameterized
const users = await prisma.user.findMany({
  where: { email: userInput.email }
});

// WRONG — raw SQL string concatenation (CRITICAL finding — SQL injection)
const users = await prisma.$queryRawUnsafe(
  `SELECT * FROM users WHERE email = '${userInput.email}'`
);
```

### 4.6 Cron Route Guards (MANDATORY)
```typescript
// CORRECT — guardCron() is FIRST operation
export async function GET(request: Request) {
  guardCron(request); // validates Vercel Cron secret header
  // job logic
}

// WRONG — business logic before guardCron() (CRITICAL finding)
export async function GET(request: Request) {
  await processAllRecords(); // runs without auth!
  guardCron(request);
}
```

### 4.7 Error Handling (MANDATORY)
```typescript
// CORRECT — generic error to client, details logged internally
try {
  // ...
} catch (error) {
  console.error("[sync_log]", { action: "process_records", error: String(error) });
  return { error: "An internal error occurred" }; // no stack trace
}

// WRONG — stack trace exposed (HIGH finding)
} catch (error) {
  return { error: error.message, stack: error.stack }; // exposes internals
}
```

---

## 5. Secrets Patterns to Flag

Any of the following patterns in source code = CRITICAL finding (`BLOCKED_SECRET_EXPOSED`):

```
sk-[a-zA-Z0-9]{20,}           # OpenAI / Anthropic API keys
Bearer [a-zA-Z0-9._-]{20,}    # Bearer tokens hardcoded
password\s*=\s*["'][^"']+["'] # Hardcoded passwords
api_key\s*=\s*["'][^"']+["']  # Hardcoded API keys
jwt_secret\s*=\s*["'][^"']+   # Hardcoded JWT secrets
DATABASE_URL\s*=\s*postgres    # Hardcoded database URLs
NEXTAUTH_SECRET\s*=\s*["']    # Hardcoded NextAuth secret
client_secret\s*=\s*["']      # OAuth client secrets
```

**Also flag**: any `.env` file committed to version control (should be in `.gitignore`).

---

## 6. Logging Privacy Rules

### audit_log — Allowed Fields Only
```typescript
// CORRECT — metadata without PII
await prisma.auditLog.create({
  data: {
    actorId: session.user.id,          // OK — internal ID
    actorEmail: session.user.email,    // OK — from session, not request
    action: "user.update_profile",     // OK — action name
    entityType: "User",                // OK — entity type
    entityId: userId,                  // OK — internal ID
    metadata: {
      fieldsUpdated: ["displayName"],  // OK — field names, not values
      timestamp: new Date().toISOString()
    }
  }
});

// WRONG — PII in metadata (HIGH finding)
metadata: {
  newEmail: userInput.email,           // WRONG — raw PII
  password: userInput.password,        // WRONG — password logged!
  fullName: userInput.name             // WRONG — raw PII
}
```

---

## 7. Data Classification Tiers

| Tier | Examples | Controls Required |
|------|----------|-------------------|
| **PUBLIC** | Marketing content, public feature names, UI labels | None beyond standard |
| **INTERNAL** | Organization config, internal IDs, business logic rules | Authenticated access, audit_log |
| **CONFIDENTIAL** | User emails, display names, preferences, usage data | Encrypted storage, data minimization, consent, deletion support |
| **RESTRICTED** | Health data, financial data, government IDs, regulated data | All CONFIDENTIAL controls + human sign-off before processing + LGPD/GDPR review + DPA if third-party |

---

## 8. Privacy Compliance Requirements (LGPD/GDPR)

| Requirement | Implementation Check |
|-------------|---------------------|
| Lawful basis / consent | Is there documented consent or legitimate interest for PII collection? |
| Data minimization | Are only necessary fields collected and stored? |
| Purpose limitation | Is the data used only for the stated purpose? |
| Storage limitation | Is there a retention policy? Are deleted records removed? |
| Right to erasure | Can a user trigger deletion of their data? |
| Data breach notification | Is there an incident response plan documented? |
| Third-party data sharing | Is a DPA in place for any third party receiving user data? |

---

## 9. Dependency Security Thresholds

| CVSS Score | Severity | Gate 5 Action |
|------------|----------|---------------|
| 9.0–10.0 | CRITICAL | Immediate block — `BLOCKED_CRITICAL_RISK` |
| 7.0–8.9 | HIGH | Must remediate before `APPROVED` |
| 4.0–6.9 | MEDIUM | Track — may proceed, must be in remediation backlog |
| 0.1–3.9 | LOW | Informational — note in audit |
| N/A | None known | Pass — document packages reviewed |

---

## 10. Gate 5 Status Codes

| Code | Meaning | Issued When |
|------|---------|-------------|
| `APPROVED` | All checks pass, no CRITICAL/unresolved HIGH findings | All 10 OWASP categories pass, secrets clean, auth verified, privacy compliant |
| `RETURNED_FOR_REVISION` | Non-critical issues found, can proceed after fix | MEDIUM or LOW findings only, or process gaps |
| `BLOCKED_CRITICAL_RISK` | Critical security risk with no mitigation | Any CRITICAL finding, or CVSS ≥ 9.0 dependency |
| `BLOCKED_SECRET_EXPOSED` | Hardcoded credential, token, key, or password found | Any secret found in source code |
| `BLOCKED_AUTH_BYPASS` | Auth check missing or bypassable | Missing `auth()` call, IDOR, userId from request body |
| `BLOCKED_PRIVACY_VIOLATION` | PII mishandled, consent missing, PII in logs | Raw PII in logs, missing consent for CONFIDENTIAL data collection |
| `BLOCKED_PENDING_HUMAN` | Decision requires human sign-off | RESTRICTED data, regulatory compliance, CRITICAL risk acceptance |

---

## 11. Trust Boundaries in the Golden Path Stack

```
Internet / Browser
    │ (untrusted — all input must be Zod-validated)
    ▼
Next.js App Router (proxy.ts — never middleware.ts)
    │
    ├── Server Components (read-only, no mutations)
    ├── Server Actions (auth() FIRST → Zod → business logic)
    └── Route Handlers (auth() FIRST → Zod → business logic)
            │
            ├── lib/env.ts (secrets boundary — all env vars)
            ├── Features layer (business logic)
            ├── DAL layer (Prisma queries — parameterized only)
            └── PostgreSQL / Supabase (trusted internal)
                        │
                 Vercel Cron (guardCron() FIRST → job logic)
```

Every crossing of a trust boundary requires validation. Input from the browser is untrusted. Output to the browser must never contain stack traces or secrets.
