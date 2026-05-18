# Agente07_DevSecOps — Knowledge Cards

> Reusable concept cards for rapid reference during security evaluations. Each card covers one security concept with definition, relevance to the Golden Path stack, and quick identification pattern.

---

## Card 001 — STRIDE

**Definition:** A structured threat modeling methodology developed at Microsoft. The acronym covers six threat categories: Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, and Elevation of Privilege.

**Purpose:** Provides systematic coverage of the threat landscape, ensuring analysts evaluate all six categories rather than only the ones they naturally think of.

**In the Golden Path stack:**
- **Spoofing** → Missing `auth()` check; session token not validated; cron job without `guardCron()`
- **Tampering** → Raw SQL concatenation; missing Zod validation; unvalidated URL redirects
- **Repudiation** → Missing `audit_log` for sensitive operations; log deletion possible
- **Information Disclosure** → Stack traces to client; PII in logs; secrets in code; IDOR
- **Denial of Service** → Unbounded Prisma queries; missing pagination; no rate limiting
- **Elevation of Privilege** → IDOR; userId from request body; missing resource-level authz

**Source:** Threat Modeling: Designing for Security (Shostack), Chapters 3–4

---

## Card 002 — OWASP Top 10 (2021)

**Definition:** Open Web Application Security Project list of the 10 most critical web application security risks, updated periodically based on real-world vulnerability data.

**2021 Edition:**
| Rank | Category | Key Risk in Golden Path |
|------|----------|------------------------|
| A01 | Broken Access Control | IDOR, missing auth check, userId from request |
| A02 | Cryptographic Failures | Secrets in code, plaintext sensitive data |
| A03 | Injection | SQL injection via raw queries, NoSQL injection |
| A04 | Insecure Design | Missing threat model, no security requirements |
| A05 | Security Misconfiguration | Default credentials, debug mode, misconfigured CORS |
| A06 | Vulnerable Components | CVE in npm dependencies |
| A07 | Identification/Auth Failures | Broken session, weak NextAuth config |
| A08 | Software & Data Integrity | Untrusted CDN, tampered deployment artifacts |
| A09 | Security Logging Failures | Missing audit_log, PII in logs, no monitoring |
| A10 | SSRF | User-controlled URLs passed to fetch() without allowlist |

**Source:** owasp.org/Top10; The Web Application Hacker's Handbook (Stuttard & Pinto)

---

## Card 003 — IDOR (Insecure Direct Object Reference)

**Definition:** A type of access control vulnerability where an application uses user-supplied input to access objects directly without verifying that the requesting user is authorized to access the specific object.

**Example in Golden Path:**
```typescript
// IDOR — fetches any user's record by ID from URL parameter
const task = await prisma.task.findUnique({
  where: { id: params.taskId }  // no userId ownership check
});
// Any authenticated user can access any task by guessing task IDs
```

**Correct Pattern:**
```typescript
// Safe — ownership check prevents IDOR
const task = await prisma.task.findFirst({
  where: {
    id: params.taskId,
    userId: session.user.id  // only returns if user owns this task
  }
});
if (!task) return { error: "Not found" }; // 404 not 403 — don't reveal existence
```

**Classification:** CRITICAL finding → `BLOCKED_AUTH_BYPASS`
**OWASP Category:** A01 Broken Access Control
**Source:** The Web Application Hacker's Handbook (Stuttard & Pinto), Chapter 8

---

## Card 004 — Parameterized Queries vs. SQL Injection

**Definition:** SQL injection occurs when user-supplied data is included in a SQL query as raw text, allowing attackers to modify the query's logic. Parameterized queries (also called prepared statements) separate the query structure from the data, preventing injection regardless of input content.

**In Prisma:**
```typescript
// SAFE — Prisma API is always parameterized
const user = await prisma.user.findFirst({ where: { email: userInput } });

// SAFE — Prisma tagged template is parameterized
const users = await prisma.$queryRaw`SELECT * FROM "User" WHERE email = ${userInput}`;

// UNSAFE — string interpolation bypasses parameterization
const users = await prisma.$queryRawUnsafe(`SELECT * FROM "User" WHERE email = '${userInput}'`);
```

**Classification:** CRITICAL finding → `BLOCKED_CRITICAL_RISK`
**OWASP Category:** A03 Injection
**Source:** The Web Application Hacker's Handbook (Stuttard & Pinto), Chapter 9

---

## Card 005 — Defense in Depth

**Definition:** A security architecture principle that applies multiple independent security controls, such that an attacker must bypass every layer to reach the target. No single layer is expected to be perfect — the combination of layers creates the security posture.

**In the Golden Path stack (layers, in order):**
1. Vercel's infrastructure security (network layer)
2. Next.js App Router access patterns (framework layer)
3. `auth()` session verification (authentication layer)
4. Resource ownership check (authorization layer)
5. Zod input validation (input layer)
6. Prisma parameterized queries (database layer)
7. `lib/env.ts` secret management (secrets layer)
8. Structured logging with `audit_log` (audit layer)

**Applied rule:** Never evaluate a layer in isolation. A gap in one layer is a finding even if other layers would catch the attack — defense in depth requires all layers to be present.

---

## Card 006 — CVSS (Common Vulnerability Scoring System)

**Definition:** A standard framework for rating the severity of security vulnerabilities in software. CVSS produces a score from 0.0 to 10.0 based on exploitability, scope, and impact.

**Score ranges:**
| Score | Severity | Gate 5 Action |
|-------|----------|---------------|
| 9.0–10.0 | CRITICAL | Immediate block |
| 7.0–8.9 | HIGH | Must remediate before APPROVED |
| 4.0–6.9 | MEDIUM | Track, plan remediation |
| 0.1–3.9 | LOW | Informational |

**How to use:** `npm audit` reports CVSS scores. For packages not in the npm advisory database, check the NIST NVD (nvd.nist.gov) or the GitHub Advisory Database.

**Source:** Practical Cloud Security (Dotson), Chapter 7

---

## Card 007 — Least Privilege

**Definition:** Every user, process, and system component should have the minimum access rights necessary to perform its intended function — and nothing more.

**In the Golden Path stack:**
- Service accounts: Supabase/Prisma connection should use a role with only the tables it needs
- User data access: queries scoped to `userId: session.user.id`
- Cron jobs: operate with a specific service identity, not as an admin user
- API keys: use keys with the minimum required scope (read-only where writes are not needed)
- Environment: each deployment environment (dev/staging/prod) should have its own secrets

**IDOR is a least privilege violation:** allowing any authenticated user to access any resource by ID is excessive privilege — the user should only be able to access their own resources.

---

## Card 008 — Privacy by Design

**Definition:** A framework that requires privacy protections to be built into systems and processes from the outset, rather than added as an afterthought. Originated with Ann Cavoukian; now a requirement of GDPR Article 25.

**Seven foundational principles:**
1. Proactive, not reactive — prevent privacy problems before they occur
2. Privacy as the default setting — maximum privacy without user action
3. Privacy embedded in design — not added as an add-on
4. Full functionality — privacy and functionality are not zero-sum
5. End-to-end security — full lifecycle protection
6. Visibility and transparency — operate openly
7. Respect for user privacy — user-centric design

**In the Golden Path stack:**
- CONFIDENTIAL data fields: not logged in `audit_log` metadata
- Deletion support: `cascade` delete in Prisma schema for user-owned data
- Data minimization: only required fields in forms and API contracts
- Consent: documented in PRD before CONFIDENTIAL data collection begins

**Source:** LGPD/GDPR compliance framework; P8

---

## Card 009 — Data Classification Tiers

**Definition:** A systematic approach to categorizing data based on its sensitivity and the harm that would result from unauthorized disclosure or modification.

**Four-tier model:**

| Tier | Definition | Examples | Controls |
|------|------------|----------|----------|
| PUBLIC | Non-sensitive data intended for broad access | Marketing content, public feature descriptions, UI labels | Standard access control |
| INTERNAL | Data for internal organization use | Internal IDs, configuration, business logic, user counts (aggregate) | Authenticated access, audit_log |
| CONFIDENTIAL | Data whose exposure causes harm to individuals | User emails, names, preferences, usage patterns, profile data | Encrypted, minimized, consented, deletable, CONFIDENTIAL label in schema comments |
| RESTRICTED | Highly sensitive regulated data | Health records, financial data, government IDs, payment details, data regulated by LGPD/GDPR/HIPAA | All CONFIDENTIAL controls + human sign-off + DPA if shared + incident response plan |

**Applied rule:** The highest tier present in a feature determines the review tier for the entire feature. One RESTRICTED field = the whole feature is reviewed at RESTRICTED tier.

---

## Card 010 — audit_log Schema

**Definition:** The structured log table for all human-initiated sensitive actions in the Golden Path stack. Defined in the reference architecture.

**Allowed fields:**
```typescript
{
  actorId: string,      // session.user.id — NEVER from request body
  actorEmail: string,   // session.user.email — NEVER from request body
  action: string,       // e.g., "task.create", "user.update_profile"
  entityType: string,   // e.g., "Task", "User"
  entityId: string,     // e.g., task.id
  metadata: {
    // Safe: field names, operation type, count, IDs
    // NEVER: field values, raw user input, passwords, tokens, PII
  },
  createdAt: DateTime   // database-generated
}
```

**Forbidden in metadata:**
- Raw user input values
- Email addresses or names as values (only as `actorEmail` from session)
- Passwords, tokens, API keys
- Full JSON blobs of request bodies
- Stack traces or error messages

**Source:** Reference Architecture — structured logging specification; P7

---

## Card 011 — guardCron() Pattern

**Definition:** A utility function in the Golden Path stack that validates that a cron route is being invoked by Vercel's cron infrastructure (via a secret header) and not by an arbitrary HTTP caller.

**Pattern:**
```typescript
// app/api/cron/process-jobs/route.ts
import { guardCron } from "@/lib/cron";

export async function GET(request: Request) {
  guardCron(request); // MUST be first — validates Authorization header against env.CRON_SECRET
  // job logic
}

// lib/cron.ts
export function guardCron(request: Request): void {
  const authHeader = request.headers.get("Authorization");
  if (authHeader !== `Bearer ${env.CRON_SECRET}`) {
    throw new Error("Unauthorized cron request");
  }
}
```

**Why it matters:** Vercel Cron jobs call `/api/cron/*` route handlers via HTTP. Without `guardCron()`, any external actor can trigger these routes by making an HTTP GET request to the same endpoint.

**Classification if missing:** CRITICAL finding → `BLOCKED_AUTH_BYPASS`

---

## Card 012 — NextAuth v5 Auth Pattern

**Definition:** The correct pattern for authentication in the Golden Path stack using NextAuth v5 with the App Router. Each protected Server Action and Route Handler must independently verify the session.

**Canonical pattern:**
```typescript
import { auth } from "@/lib/auth";

export async function protectedAction(input: unknown) {
  // Step 1: Authenticate — MUST be first operation
  const session = await auth();
  if (!session) {
    return { error: "Unauthorized" };
  }
  
  // Step 2: Validate input (after auth — no point validating if not authenticated)
  const parsed = InputSchema.safeParse(input);
  if (!parsed.success) {
    return { error: "Invalid input" };
  }
  
  // Step 3: Authorize — verify user can access the requested resource
  const resource = await dal.findUserResource(parsed.data.resourceId, session.user.id);
  if (!resource) {
    return { error: "Not found" }; // 404, not 403 — don't reveal existence
  }
  
  // Step 4: Execute business logic
  return await serviceLayer.performAction(resource, parsed.data);
}
```

**What to check in audit:**
1. `auth()` is the FIRST call
2. Session null-check is present and returns/throws immediately
3. Input goes through Zod before use
4. Resource queries include `userId: session.user.id`
5. userId is sourced from `session.user.id`, never from `parsed.data`

**Source:** P11, DR002, FM-02
