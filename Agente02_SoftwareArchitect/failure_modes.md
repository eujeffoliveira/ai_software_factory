# Failure Modes — Agente02_SoftwareArchitect

_Known failure modes with symptoms, causes, detection, and resolution actions._

---

## FM-01 — Over-Engineering

**Symptom:** Architecture document includes microservices, message queues, distributed caches, or event sourcing for a project that the PRD describes as a standard CRUD SaaS application.

**Cause:** Architect conflates technical sophistication with architecture quality; extrapolating from theoretical patterns without validating against PRD non-functional requirements.

**Detection:** Tech Lead review finds architectural decisions not traceable to specific PRD requirements.

**Agent Action:**
1. Re-read every non-functional requirement in the PRD.
2. For each complex pattern, ask: "Which PRD requirement justifies this complexity?"
3. Remove patterns that have no PRD justification.
4. Replace with the simplest Golden Path equivalent.

**Escalate to Tech Lead when:** The simplest solution is genuinely insufficient for a PRD requirement that implies scale (e.g., millions of concurrent users, sub-100ms latency requirements).

**Artifact to correct:** `Architecture.md` — simplify, re-run `golden-path-compliance-skill`.

**Blocks flow:** YES — Gate 2 will return `RETURNED_FOR_REVISION`.

---

## FM-02 — Missing ADR for Golden Path Deviation

**Symptom:** Architecture.md proposes a non-Golden-Path technology (Redis, MongoDB, separate backend, etc.) without a corresponding ADR.

**Cause:** Architect forgets to run `golden-path-compliance-skill`, or assumes the deviation is minor and doesn't need documentation.

**Detection:** Gate 2 review by Tech Lead; golden-path-compliance-skill checklist; agent_config.json `adr_required_for` list.

**Agent Action:**
1. Invoke `golden-path-compliance-skill` on Architecture.md.
2. For every deviation identified, invoke `adr-authoring-skill`.
3. Set ADR status to PROPOSED.
4. Reference ADR in Architecture_Decisions.md.
5. Resubmit to Gate 2.

**Escalate to Tech Lead when:** The deviation involves significant cost or requires business approval.

**Artifact to correct:** `Architecture_Decisions.md`, create `docs/adr/ADR-NNN-*.md`.

**Blocks flow:** YES — Gate 2 returns `BLOCKED_PENDING_ADR`.

---

## FM-03 — Thin or Incomplete context_view

**Symptom:** Agent makes architectural decisions inconsistent with the Golden Model — for example, using `middleware.ts` instead of `proxy.ts`, or designing mutations as GET requests.

**Cause:** Context view was not compiled properly at build time, or the agent is consulting stale knowledge.

**Detection:** Any architectural decision that contradicts the mandatory rules in `context_view.md`.

**Agent Action:**
1. Re-read `context_view.md` Section 1–3 (Golden Model, Principles, Rules).
2. Cross-check every technology decision against Section 1.2.
3. Cross-check every pattern against Section 12 (Anti-Patterns).
4. Correct the violation in Architecture.md.

**Escalate to Tech Lead when:** A build-time issue is suspected (context_view.md appears incomplete or outdated).

**Artifact to correct:** `Architecture.md` — apply correct pattern.

**Blocks flow:** YES if violation reaches Gate 2.

---

## FM-04 — Implicit API Contracts

**Symptom:** `API_Contract.json` is present but contains placeholder types (`type: object` with no properties), missing auth requirements, or endpoints referenced in Architecture.md that are absent from the contract.

**Cause:** Contract written at too high a level; architect treats API design as documentation-only rather than as an executable contract.

**Detection:** `api_contract_checklist.md` review; downstream DevBackend agents cannot implement without complete contracts.

**Agent Action:**
1. Run `checklists/api_contract_checklist.md` on API_Contract.json.
2. For every endpoint in Architecture.md, verify it appears in API_Contract.json.
3. Complete every schema with typed properties.
4. Add security scheme to every protected endpoint.
5. Add error response codes to every endpoint.

**Escalate to Tech Lead when:** An endpoint design requires business input (e.g., ambiguity between two valid design choices that affect product behavior).

**Artifact to correct:** `API_Contract.json`.

**Blocks flow:** YES — Gate 2 returns `RETURNED_FOR_REVISION`.

---

## FM-05 — Missing Risk Register

**Symptom:** Architecture.md is submitted without a `Risk_Register.md`, or the risk register exists but classifies all risks as LOW regardless of actual exposure.

**Cause:** Risk identification skipped under time pressure; architect confuses architecture with happy-path documentation.

**Detection:** Gate 2 checklist; Tech Lead review.

**Agent Action:**
1. Re-read Architecture.md looking for: new external dependencies, complex migrations, high-volume operations, security-sensitive components, irreversible decisions.
2. For each item, create a RISK-NNN entry with classification and mitigation.
3. Any CRITICAL risk without a clear mitigation must be escalated.

**Escalate to Tech Lead when:** A CRITICAL risk cannot be mitigated at architecture level.

**Artifact to correct:** `Risk_Register.md`.

**Blocks flow:** YES — CRITICAL unmitigated risks block Gate 2.

---

## FM-06 — Database Schema Violates Prisma Conventions

**Symptom:** Prisma schema lacks `@map` / `@@map` annotations; column names are camelCase in the database; no data privacy classification.

**Cause:** Schema written without consulting `context_view.md` §6 Database conventions; privacy classification skipped.

**Detection:** `database_modeling_checklist.md`; DevBackend agent raises type conflicts.

**Agent Action:**
1. Run `checklists/database_modeling_checklist.md`.
2. Add `@map("snake_case")` to all field names.
3. Add `@@map("snake_case_plural")` to all model names.
4. Identify and annotate all PII fields.
5. Verify migration risk classification for each change.

**Escalate to Tech Lead when:** Schema requires a destructive migration in production.

**Artifact to correct:** `Prisma_Schema_Proposal.prisma`.

**Blocks flow:** YES if conventions are violated at Gate 2.

---

## FM-07 — Security Strategy Omitted or Superficial

**Symptom:** `Security_Strategy.md` is missing, or contains only one line ("use HTTPS"). The 5 mandatory threat modeling questions are not answered for each endpoint.

**Cause:** Security treated as DevSecOps responsibility only; architect does not recognize threat modeling as part of architecture design.

**Detection:** `security_architecture_checklist.md`; DevSecOps agent review.

**Agent Action:**
1. Run `checklists/security_architecture_checklist.md`.
2. For every endpoint in `API_Contract.json`, answer the 5 threat modeling questions.
3. Classify all data fields (PII, sensitive, operational).
4. Define `audit_log` instrumentation for sensitive actions.
5. Invoke `security-architecture-skill` to complete the strategy.

**Escalate to Tech Lead when:** A CRITICAL security risk is found that cannot be mitigated at architecture level (e.g., a fundamental design that exposes PII without technical mitigation).

**Artifact to correct:** `Security_Strategy.md`.

**Blocks flow:** YES — incomplete security strategy blocks Gate 2.

---

## FM-08 — Deployment Strategy Lacks Rollback Plan

**Symptom:** `Deployment_Strategy.md` describes deployment steps but contains no rollback plan, or the rollback plan is limited to "revert Vercel deploy" without addressing migration impact.

**Cause:** Rollback planning deferred to DevOps; architect does not recognize rollback as a Gate 6 prerequisite that must be designed at Gate 2.

**Detection:** `deployment_strategy_checklist.md`; Gate 6 pre-condition check.

**Agent Action:**
1. For every schema migration, classify: reversible / compatible / irreversible / destructive.
2. For destructive migrations, define a phased plan (compatibility → migration → cleanup).
3. Define rollback triggers, responsible party, and validation steps.
4. Complete `Deployment_Strategy.md` rollback section.

**Escalate to Tech Lead when:** A migration is irreversible or destructive and requires explicit human approval before Gate 6.

**Artifact to correct:** `Deployment_Strategy.md`.

**Blocks flow:** DELAYED — does not block Gate 2 but will block Gate 6.

---

## FM-09 — Architecture Disconnected from PRD

**Symptom:** Architecture.md is technically correct but does not address key acceptance criteria from the PRD; or it addresses features not in the PRD scope.

**Cause:** Architect reads architecture patterns from knowledge/ without re-reading the PRD acceptance criteria; scope drift.

**Detection:** Gate 2 cross-validation between PRD.md and Architecture.md by Tech Lead.

**Agent Action:**
1. Create a traceability matrix: PRD requirement → architecture decision.
2. Identify any PRD requirement without an architectural decision.
3. Identify any architectural decision without a PRD justification.
4. Add missing decisions; remove unjustified ones.

**Escalate to Tech Lead when:** A PRD requirement is technically impossible without significant scope change.

**Artifact to correct:** `Architecture.md`.

**Blocks flow:** YES — Gate 2 returns `RETURNED_FOR_REVISION`.

---

## FM-10 — Attempting to Scope Beyond Architecture Role

**Symptom:** Agent writes final TypeScript code in Architecture.md; attempts to write Execution_Plan.json tasks; makes QA validation decisions.

**Cause:** Helpful intent without role boundary awareness.

**Detection:** Output format review; Tech Lead identifies out-of-scope content.

**Agent Action:**
1. Remove code from Architecture.md — replace with pseudocode or component descriptions.
2. Do not produce Execution_Plan.json — that is Agente03's responsibility.
3. Stop if attempting to validate PRD acceptance criteria — that is Agente06's responsibility.

**Escalate to Tech Lead when:** It is unclear whether a deliverable belongs to Agente02 or another agent.

**Artifact to correct:** Trim Architecture.md to design-level content only.

**Blocks flow:** NO — but creates confusion downstream.
