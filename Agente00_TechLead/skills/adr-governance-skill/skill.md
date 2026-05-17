# ADR Governance Skill

## Purpose
Detect Golden Path deviations, initiate ADR requests, track ADR status, and enforce gate blocks until ADRs are formally resolved.

## When to Use
- Any time an agent's artifact proposes technology or patterns not in the Golden Model
- After a tollgate validation detects a deviation
- When reviewing an ADR submitted by another agent
- When resolving a BLOCKED_PENDING_ADR gate

## Golden Model — Deviation Triggers

### Technology Deviations (always require ADR)
- Database: anything other than PostgreSQL / Supabase
- ORM: anything other than Prisma 7
- Frontend: anything other than Next.js 16 + App Router + React 19
- Auth: anything other than NextAuth v5 + Google OAuth
- Hosting: anything other than Vercel
- CSS: anything other than Tailwind CSS v4
- Testing: anything other than Vitest (unit) + Playwright (E2E)
- Charting: anything other than Recharts v3
- Validation: anything other than Zod
- Jobs: anything other than Vercel Cron

### Architecture Pattern Deviations (always require ADR)
- Using `middleware.ts` instead of `proxy.ts` in Next.js 16
- Using `prisma db push` in staging or production
- Non-idempotent automated job
- Synchronous external API call from Server Component without timeout/fallback
- Storing secrets outside environment variables
- Pages Router instead of App Router
- Client-only data fetching where Server Component fetching is possible

### Irreversible Decision Deviations (require ADR + human approval)
- Dropping a database table or column in production
- Removing a public API endpoint
- Changing authentication provider
- Major dependency version downgrades affecting behavior

## Inputs
- `deviation_identified` — description of what was found
- `golden_path_violated` — which specific rule was violated
- `source_artifact` — which artifact contains the deviation
- `council_verdict` — optional, if Council already deliberated
- `proposed_adr` — optional, if the submitting agent already wrote the ADR

## Outputs
- `adr_request` — formal ADR request object
- `gate_block_required` — boolean (always true for technology deviations)
- `human_approval_required` — boolean (true for irreversible decisions)
- `adr_id` — assigned ADR identifier
- `resolution_path` — what must happen to unblock the gate

## ADR Structure (per request)

An approved ADR must contain:
1. **ADR-XXX** — sequential ID
2. **Date** — submission date
3. **Status** — PROPOSED / APPROVED / REJECTED / SUPERSEDED
4. **Context** — why the decision is needed
5. **Decision** — exactly what is being changed from Golden Model
6. **Consequences** — positive and negative
7. **Alternatives Considered** — at least 2 alternatives
8. **Approval** — who approved and when

## Procedure

1. Receive deviation report (from tollgate or direct observation)
2. Classify deviation: technology / architecture pattern / irreversible
3. Assign ADR ID (`ADR-{sequential_number}`)
4. If Council verdict exists: incorporate into ADR context
5. Set `gate_block_required = true`
6. Set `human_approval_required` based on category
7. Write ADR request using `templates/ADR_Request.md`
8. Return ADR request + resolution path

## ADR Resolution

To resolve a BLOCKED_PENDING_ADR gate:
1. Submitting agent writes the full ADR
2. Tech Lead reviews: is the justification sufficient? Are alternatives documented?
3. If deviation is technology-level: Council deliberation mandatory before approval
4. Approved ADR unblocks the gate — update State Ledger
5. Rejected ADR: agent must revert to Golden Model

## Quality Gate
No ADR can be approved without documenting at least 2 alternatives considered. "We tried X and it didn't work" must cite specific failure evidence.

## Failure Modes
- Retroactive ADR (deviation already implemented) → CRITICAL severity, mandatory human review
- ADR approved without Council deliberation for technology-level deviation → ADR revoked
- ADR with no alternatives documented → returned to submitting agent

## RAG Authorized
- `golden_model` — tech stack standards and pattern rules
- `factory_architecture` — ADR policy and governance process
- `project_state` — existing ADRs in State Ledger

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/` (especially `decision_rules.md` for ADR trigger rules)
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
