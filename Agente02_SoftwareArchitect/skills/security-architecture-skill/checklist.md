# security-architecture-skill Checklist

## Pre-execution
- [ ] `Architecture.md` available with auth strategy and component list
- [ ] `API_Contract.json` available — all endpoints to be threat-modeled are present
- [ ] `Prisma_Schema_Proposal.prisma` available — PII field identification requires schema
- [ ] User roles from PRD confirmed (RECRUITER, CANDIDATE, ADMIN, or project-specific)
- [ ] Existing `Risk_Register.md` path known to avoid RISK-NNN collision

## During execution

### Data classification
- [ ] Every entity and field in Prisma schema classified: PUBLIC / INTERNAL / CONFIDENTIAL / PII / PII_SENSITIVE
- [ ] Classification table complete — no entity without a classification
- [ ] PII fields identified for `database-modeling-skill` annotation (`/// @privacy: PII`)

### Authentication
- [ ] NextAuth v5 + Google OAuth confirmed as auth provider (or ADR documenting deviation)
- [ ] Session storage: httpOnly cookies (never localStorage — documented explicitly)
- [ ] Token lifetime stated
- [ ] Sign-out behavior documented (cookie invalidation, session revocation)
- [ ] All public (unauthenticated) routes explicitly listed and justified

### Authorization
- [ ] RBAC matrix defined: each role × each resource × each operation (read/create/update/delete)
- [ ] Ownership checks defined: resource-level authorization (e.g., "only owning company can edit job")
- [ ] Enforcement point confirmed: Server Action or DAL function — never React component or middleware.ts

### Threat modeling — 5 questions per endpoint
For EACH endpoint in API_Contract.json:
- [ ] Q1: Who can call this endpoint? (authenticated / role / public)
- [ ] Q2: What can they do with the response? (data exfiltration risk)
- [ ] Q3: What happens with malformed or adversarial input? (injection, DoS)
- [ ] Q4: Blast radius if compromised? (impact scope)
- [ ] Q5: What audit trail exists if abused?
- [ ] Threat level assigned: LOW / MEDIUM / HIGH / CRITICAL
- [ ] CRITICAL threats written to Risk_Register.md with escalation flag

### Security controls
- [ ] Rate limiting specified for all public/unauthenticated endpoints
- [ ] Input validation: Zod schema at every POST/PATCH endpoint boundary
- [ ] Output sanitization: no raw SQL errors or stack traces in API responses
- [ ] CORS policy defined: explicit allowed origins, never `*` on authenticated endpoints
- [ ] Secrets management: all via `lib/env.ts`, `.env` files not committed

## Post-execution
- [ ] `Security_Strategy.md` written to project artifacts folder
- [ ] `escalation_required: true` if any CRITICAL risk exists
- [ ] CRITICAL risks have Tech Lead notified — Gate 5 blocked until approved
- [ ] `pii_fields_classified: true`
- [ ] `auth_strategy_complete: true`
- [ ] `secrets_management_compliant: true`
- [ ] `compliance_gaps` list is empty (or CRITICAL risks escalated)
- [ ] Data classification fed back to `database-modeling-skill`
- [ ] `audit_log` requirements fed to `observability-design-skill`

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/`, `Agente02_SoftwareArchitect/context_view.md`, and project artifacts as input only
