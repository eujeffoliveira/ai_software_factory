# security-architecture-skill

## Purpose

Produce a formal threat model and define security controls, data classification, authentication/authorization strategy, and audit logging requirements for the system. The output (`Security_Strategy.md`) is consumed by Agente05_DevSecOps as the security baseline for Gate 5. No CRITICAL security risk may proceed without human escalation — this skill cannot self-approve such risks.

## When to Use

- During architecture design, before finalizing `Architecture.md`
- When a new endpoint, integration, or data model is introduced
- When DevSecOps raises a security concern during gate review
- When the PRD introduces new roles, permissions, or sensitive data types

## Inputs

- `Architecture.md` — draft; component inventory, auth strategy, data flows
- `API_Contract.json` — draft; endpoints, request/response schemas, security declarations
- `Prisma_Schema_Proposal.prisma` — draft; data models, PII fields
- `context_view_path` — `Agente02_SoftwareArchitect/context_view.md` (§8 Security, §3 P2 Security by default)
- `templates/Security_Strategy.md` — base template

## Outputs

- `Security_Strategy.md` — primary output; threat model, controls, data classification, auth/authz strategy
- Data classification notes fed back into `database-modeling-skill` (annotate PII fields)
- `audit_log` instrumentation requirements fed into `observability-design-skill`

## Procedure

1. **Data classification** — classify every data entity and field:
   - `PUBLIC`: openly accessible, no harm if disclosed
   - `INTERNAL`: requires authentication, no special handling
   - `CONFIDENTIAL`: business-sensitive (salaries, rejection reasons, internal notes)
   - `PII`: personally identifiable (name, email, phone, address)
   - `PII_SENSITIVE`: highly sensitive (SSN, passport, health data, financial data)
   
   Write the classification table. Block `database-modeling-skill` if PII fields are not classified yet.

2. **Authentication design** — for NextAuth v5 + Google OAuth:
   - Document the session token type: JWT
   - State where tokens are stored: httpOnly cookies only (never localStorage)
   - State the token lifetime and refresh strategy
   - Document the sign-out behavior (cookie invalidation)
   - Identify all routes that bypass authentication — must be explicitly listed and justified

3. **Authorization design (RBAC/ABAC)** — for each user role defined in the PRD:
   - List the role
   - List what resources the role can read, create, update, delete
   - Identify resource-level authorization: ownership checks (e.g., "only the job's owning company can edit it")
   - State the enforcement point: server-side check in Server Action or DAL function — never client-side only

4. **Threat modeling — 5 mandatory questions per endpoint** — for every endpoint in `API_Contract.json`:
   - Q1: Who can call this endpoint? (authentication: none/user/admin)
   - Q2: What can they do with the response? (data exfiltration risk)
   - Q3: What happens if input is malformed or adversarial? (injection, DoS)
   - Q4: What is the blast radius if this endpoint is compromised? (impact)
   - Q5: What audit trail exists if this endpoint is abused? (auditability)
   
   For each endpoint, summarize threat level: LOW / MEDIUM / HIGH / CRITICAL.

5. **Security controls** — define controls for each threat level:
   - Rate limiting: specify which endpoints need rate limiting and the limit (req/min per IP or user)
   - Input validation: Zod schemas at all system boundaries (every POST/PATCH body)
   - Output sanitization: no raw SQL errors in API responses; no stack traces in production
   - CORS policy: define allowed origins explicitly; never `origin: '*'` on authenticated endpoints
   - CSP headers: define Content-Security-Policy via `next.config.ts` headers
   - HTTPS: enforced at Vercel level; document this explicitly

6. **Secrets management** — verify:
   - All secrets accessed via `lib/env.ts` (validated with Zod at startup)
   - No hardcoded tokens, API keys, or credentials in source code
   - `.env.local` and `.env.production` not committed to repository

7. **CRITICAL risk handling** — if any endpoint or data flow is classified as CRITICAL:
   - Do not attempt to self-mitigate and close the risk
   - Write the risk to `Risk_Register.md` with classification `CRITICAL`
   - Escalate to Tech Lead for human decision
   - Gate 5 remains `BLOCKED_PENDING_SECURITY` until the Tech Lead approves the mitigation

8. **Populate `Security_Strategy.md`** using the template structure.

## Quality Gate

`Security_Strategy.md` passes this skill's quality check when:
- Data classification table covers all entities and fields in the Prisma schema
- All 5 threat modeling questions answered for every endpoint
- No endpoint has threat level CRITICAL without a corresponding Risk_Register.md entry
- Authentication strategy documents session storage (httpOnly cookies), token lifetime, and sign-out behavior
- Authorization checks are server-side for all mutations and privileged reads
- Rate limiting specified for all public/unauthenticated endpoints
- Secrets management compliance confirmed (all via `lib/env.ts`)

## Failure Modes

- **Incomplete threat model:** Not running all 5 questions for each endpoint → run `checklists/security_architecture_checklist.md` before submitting
- **Missing data classification:** PII fields not identified before schema finalized → block `database-modeling-skill` until classification is done
- **Self-accepting CRITICAL risk:** Writing "risk accepted" for a CRITICAL-level threat without Tech Lead approval → hard block; escalate immediately
- **Client-side authorization:** Authorization check in React component or middleware.ts → authorization must be enforced server-side in Server Actions or DAL
- **Raw PII in responses:** API endpoint returns unmasked user email in list responses → all list endpoints must scope to the authenticated user's own data or apply masking

## RAG Policy

Authorized collections at runtime:
- `architecture_reference_full` (context_view.md §8 Security, §3 P2 Security by default)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill's output must comply with:
- `context_view.md §8` — Security requirements
- `context_view.md §3 P2` — Security by default principle
- `checklists/security_architecture_checklist.md`

Gate 5 (Security) block cannot be overridden by the Tech Lead — human escalation is required for all CRITICAL risks.

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
