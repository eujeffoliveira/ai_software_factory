# Definition of Done — Architecture.md

## Overview

Architecture.md is the technical blueprint that translates product requirements into implementation decisions. It defines the system's structure, the selected Golden Model, all API contracts, the database schema, and the strategies for security, observability, and testing. Every backend, frontend, and infrastructure decision made by downstream agents must trace back to a decision recorded here.

## Owner Agent

- **Primary:** `@architect` (Agente02_SoftwareArchitect)
- **Gate:** Gate 2 — Architecture Review

## Required Fields / Sections

### Golden Model Compliance
- [ ] `project_archetype` is explicitly declared and matches the value in the approved PRD
- [ ] The selected Golden Model file is referenced (e.g., `standards/golden-model-web-app.md`)
- [ ] Every component in the architecture uses only stack elements from the selected Golden Model
- [ ] Any deviation from the Golden Model is documented in an ADR (see ADR section below)
- [ ] No deviation exists without a corresponding approved ADR — Gate 2 is blocked until ADR is approved

### Component Map
- [ ] All system components are named and placed in the correct project structure (e.g., `features/`, `lib/`, `app/api/`)
- [ ] Data flow between components is described (which component calls which)
- [ ] External dependencies (third-party APIs, external services) are identified
- [ ] Component responsibilities are stated in one sentence each — no component has more than one primary responsibility

### API Contract (`API_Contract.json`)
- [ ] File exists at the documented path
- [ ] Every endpoint has: HTTP method, path, request schema, response schema, HTTP status codes
- [ ] Authentication requirement is stated per endpoint (`auth_required: true/false`)
- [ ] Request and response schemas use Zod-compatible types (for `web_app` archetype)
- [ ] Pagination strategy defined for any list endpoint
- [ ] Error response format is consistent across all endpoints
- [ ] Webhook payloads documented if applicable
- [ ] Contract is traceable to at least one functional requirement from the PRD

### Database Schema
- [ ] `prisma/schema.prisma` (or equivalent) is complete and matches the API contract's data shapes
- [ ] All entities have a primary key, `createdAt`, and `updatedAt` fields
- [ ] Relations are explicitly defined (one-to-many, many-to-many)
- [ ] Indexes are defined for all fields used in `WHERE` clauses of anticipated queries
- [ ] Sensitive fields are identified and marked for encryption or hashing
- [ ] Migration strategy is stated: `prisma migrate dev` for development, `prisma migrate deploy` for staging/production
- [ ] No `prisma db push` in any environment (explicitly prohibited)

### Security Strategy
- [ ] Authentication mechanism is specified (e.g., NextAuth v5 + Google OAuth)
- [ ] Authorization model is defined: who can perform which actions on which resources
- [ ] IDOR (Insecure Direct Object Reference) prevention strategy is stated
- [ ] All sensitive data fields are identified with their protection mechanism (hashing, encryption, tokenization)
- [ ] Secret management approach is stated (all secrets via `lib/env.ts` or equivalent, never hardcoded)
- [ ] LGPD/GDPR data classification is present if the system handles personal data
- [ ] Rate limiting strategy defined for public or authenticated endpoints

### Observability Strategy
- [ ] Logging strategy defined: structured JSON, `audit_log` for human actions, `sync_log` for automated jobs
- [ ] Monitoring approach stated (e.g., Vercel Analytics, external APM)
- [ ] Alerting thresholds defined for critical operations
- [ ] Error tracking approach stated (e.g., Sentry, structured console errors)
- [ ] Health check endpoint documented

### Testing Strategy
- [ ] Unit test coverage target stated (minimum 80%)
- [ ] Integration test scope defined
- [ ] E2E test scope defined (minimum: happy paths for all user-facing flows)
- [ ] Test tooling specified (e.g., Vitest for unit, Playwright for E2E)
- [ ] Mocking strategy for external dependencies stated
- [ ] Performance test requirements stated if NFRs include response time thresholds

### Architecture Decision Records (ADRs)
- [ ] An ADR exists for every deviation from the selected Golden Model
- [ ] Each ADR follows the format: context, decision, alternatives considered, consequences
- [ ] Each ADR has a status: `proposed`, `accepted`, `superseded`, `deprecated`
- [ ] No ADR is in `proposed` status at Gate 2 submission — all must be `accepted`
- [ ] ADRs are numbered sequentially (`ADR-001`, `ADR-002`, ...)

### Handoff Package
- [ ] `required_next_agent` set to `"Agente03_SoftwareEngineer"`
- [ ] `gate_ready` set to `true`
- [ ] `api_contract_path` populated
- [ ] `schema_path` populated
- [ ] `open_questions` confirms no blocking items remain
- [ ] `risks` list populated with technical risks and mitigations

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| Golden Model compliance | List every technology in Architecture.md; check each against the selected Golden Model spec |
| API_Contract.json complete | Open the file; verify every endpoint has method, path, request schema, response schema, and status codes |
| No unapproved Golden Model deviations | Search for any technology not in the Golden Model; each must have an `accepted` ADR |
| Security strategy addresses IDOR | Read authorization section; confirm resource-level ownership check is described |
| Prisma schema aligns with API contract | Compare entity fields in `schema.prisma` against request/response shapes in `API_Contract.json` |
| All ADRs are `accepted` | Read each ADR's status field; reject if any is `proposed` |
| Testing strategy states 80% coverage target | Read testing section; reject if coverage target is absent or below 80% |
| Migration strategy excludes `prisma db push` | Search Architecture.md for "db push"; must not appear as an approved command |

## Related Gates

- **Prerequisite:** Gate 1 approved (PRD.md must be approved before architecture begins)
- **This gate:** Gate 2 — Architecture Review (evaluated by Agente00_TechLead)
- **Unblocks:** Gate 3 — Execution Plan (Agente03_SoftwareEngineer consumes Architecture.md and API_Contract.json)

## Gate 2 Status Codes

| Code | Meaning |
|------|---------|
| `APPROVED` | Architecture meets all criteria; pipeline advances to Gate 3 |
| `RETURNED_FOR_REVISION` | Architecture has gaps or violations; returned to Software Architect |
| `BLOCKED_PENDING_ADR` | A Golden Model deviation was found without an accepted ADR |

## Failure Examples

- **FAIL:** Architecture.md uses `Express.js` as the API framework for a `web_app` archetype project. The Golden Model mandates Next.js App Router Route Handlers. No ADR exists for this deviation.
- **FAIL:** `API_Contract.json` has 8 endpoints but 3 are missing response schemas. The Dev Backend cannot implement error handling without knowing the expected response shape.
- **FAIL:** The database schema has a `users` table with no indexes on `email` or `userId`, but the API contract has 5 endpoints that query by those fields.
- **FAIL:** The security strategy says "we will use JWT" but does not specify how tokens are validated, where they are stored, or how IDOR is prevented.
- **FAIL:** An ADR exists for using SQLite instead of PostgreSQL but its status is `proposed`, not `accepted`. Gate 2 cannot be approved.
- **FAIL:** The testing strategy section is one sentence: "We will write unit tests." No coverage target, no tooling, no scope for integration or E2E tests.

## When to Block

Return `BLOCKED_PENDING_ADR` when any technology or pattern in Architecture.md is not in the selected Golden Model and has no corresponding `accepted` ADR.

Return `RETURNED_FOR_REVISION` when:
- `API_Contract.json` is missing or has endpoints without complete schemas
- The security strategy does not address authentication, authorization, and IDOR prevention
- The testing strategy omits a coverage target or test tooling
- The database schema contradicts the API contract's data shapes
- Any CRITICAL risk has no mitigation plan

Issue `APPROVED` only when every checkbox in this document is checked and no ADRs remain in `proposed` status.
