# Skills Manifest — Agente02_SoftwareArchitect

_All authorized skills for the Software Architect agent._  
_Runtime: read-only. Invoke skills by name as defined below._

---

## Skill Index

| Skill | Purpose | Primary Output |
|-------|---------|----------------|
| `architecture-design-skill` | Design system components and layers | `Architecture.md` |
| `golden-path-compliance-skill` | Validate architecture against Golden Model | Compliance report |
| `adr-authoring-skill` | Write Architecture Decision Records | `ADR-NNN.md` |
| `api-contract-design-skill` | Define OpenAPI/Swagger contracts | `API_Contract.json` |
| `database-modeling-skill` | Design schema and data access patterns | `Prisma_Schema_Proposal.prisma` or `DB_Schema.sql` |
| `migration-risk-analysis-skill` | Classify and plan migration risks | Risk classification in `Risk_Register.md` |
| `architecture-tradeoff-analysis-skill` | Analyze and document trade-offs | Trade-off section in `Architecture.md` |
| `observability-design-skill` | Define logging, metrics, APM strategy | `Observability_Strategy.md` |
| `security-architecture-skill` | Threat modeling and security controls | `Security_Strategy.md` |
| `deployment-strategy-skill` | Define deploy, cron, and rollback strategy | `Deployment_Strategy.md` |

---

## Skill Details

---

### `architecture-design-skill`

**Purpose:** Transform an approved PRD into a coherent technical architecture document that describes all system components, layers, data flows, integration points, and technology decisions.

**When to use:**
- Immediately after receiving an approved `PRD.md`
- When the architecture must be revised after a Gate 2 rejection
- When a structural change is requested by the Tech Lead

**Inputs:**
- `PRD.md` (approved)
- `Open_Questions.md`
- `context_view.md` (Golden Model reference)
- `knowledge/principles.md`
- Existing ADRs (if any)

**Outputs:**
- `Architecture.md` — system overview, layers, flows, integrations
- Draft `Architecture_Decisions.md` — listing all decisions made

**Failure modes:**
- Over-engineering: adding layers PRD does not require → simplify, document why
- Missing data flows: omitting a critical path → re-read PRD acceptance criteria
- Technology assumptions: choosing stack without verifying Golden Path → run golden-path-compliance-skill first

**Quality gate:** Architecture.md must map every non-functional requirement in the PRD to a specific architectural decision.

**RAG permitted:** `architecture_reference_full`, `software_architecture_fundamentals`, `clean_architecture`, `domain_driven_design`

**Architecture compliance:** Must follow Golden Path. Deviations trigger `adr-authoring-skill`.

---

### `golden-path-compliance-skill`

**Purpose:** Validate a draft architecture against the Golden Model to identify all deviations that require an ADR.

**When to use:**
- After completing `Architecture.md` draft
- Before submitting to Gate 2
- When evaluating a proposed technology change

**Inputs:**
- Draft `Architecture.md`
- `context_view.md` (§1 Golden Model)
- `agent_config.json` (adr_required_for list)
- `checklists/golden_path_compliance_checklist.md`

**Outputs:**
- Compliance report appended to `Architecture_Decisions.md`
- List of required ADRs (if any)
- `COMPLIANT` or `REQUIRES_ADR` classification per decision

**Failure modes:**
- False compliance: marking a deviation as compliant → always re-check against the adr_required_for list
- Partial scan: checking only technology stack, not patterns → check anti-patterns list too

**Quality gate:** Every non-compliant decision must produce an ADR request.

**RAG permitted:** `architecture_reference_full`, `decision_rules_index`

**Architecture compliance:** This skill IS the compliance check — it is never skipped.

---

### `adr-authoring-skill`

**Purpose:** Write a properly structured Architecture Decision Record for any Golden Path deviation or irreversible architectural decision.

**When to use:**
- When `golden-path-compliance-skill` identifies a deviation
- When any decision is irreversible or expensive to reverse
- When a new external service, tool, or pattern not in the Golden Path is introduced

**Inputs:**
- Decision context (from Architecture.md or Tech Lead brief)
- `templates/ADR_Template.md`
- `context_view.md` (§4 ADR Governance)

**Outputs:**
- `docs/adr/ADR-NNN-kebab-case-title.md`
- Updated `Architecture_Decisions.md` with ADR reference

**Failure modes:**
- Vague context: not explaining the problem clearly → include failing scenario
- Missing alternatives: not documenting rejected options → always include 2+ alternatives
- Immediate approval: marking as APPROVED without Tech Lead review → status must start as PROPOSED

**Quality gate:** ADR is complete when all sections are filled and status is at minimum PROPOSED.

**RAG permitted:** `architecture_reference_full`, `decision_rules_index`

**Architecture compliance:** ADR format follows §4 of context_view.md.

---

### `api-contract-design-skill`

**Purpose:** Define all API endpoints in OpenAPI/Swagger format, including request/response schemas, authentication requirements, and error codes.

**When to use:**
- After completing `Architecture.md`
- When defining new endpoints for a feature
- When revising contracts after a Gate 2 rejection

**Inputs:**
- `Architecture.md` (completed)
- `PRD.md` (for functional requirements and acceptance criteria)
- `context_view.md` (§5.2 Route Handler Rule)
- `templates/API_Contract.json`

**Outputs:**
- `API_Contract.json` — OpenAPI 3.1 specification

**Failure modes:**
- Missing auth requirements: not specifying which endpoints require authentication → every protected endpoint must have security scheme
- Vague schemas: using `type: object` without properties → every schema must be fully typed
- Logic in routes: designing contracts that imply business logic in route.ts → redesign to keep route.ts as thin shell

**Quality gate:** Every endpoint defined in Architecture.md must appear in API_Contract.json.

**RAG permitted:** `architecture_reference_full`, `domain_driven_design`

**Architecture compliance:** Route handlers must be thin shells per §5.2 of context_view.md.

---

### `database-modeling-skill`

**Purpose:** Design the relational database schema using Prisma 7 conventions, classify data fields by privacy sensitivity, and identify indexing strategy.

**When to use:**
- After completing `Architecture.md`
- When adding a new domain entity to an existing schema
- When revising the data model after a Gate 2 rejection

**Inputs:**
- `Architecture.md` (domain entities identified)
- `PRD.md` (data requirements)
- `context_view.md` (§6 Database conventions)
- `templates/Prisma_Schema_Proposal.prisma`
- `templates/DB_Schema.sql`

**Outputs:**
- `Prisma_Schema_Proposal.prisma` — primary output
- `DB_Schema.sql` — supplementary relational schema
- Data classification notes in `Security_Strategy.md`

**Failure modes:**
- Missing @map annotations: using Prisma camelCase in DB directly → always apply @map/@@map
- Missing privacy classification: not identifying PII fields → classify before modeling
- Overusing transactions: designing flows that require long transactions → redesign using checkpoints or upserts

**Quality gate:** Every entity in Architecture.md must have a corresponding Prisma model. All PII fields must be classified.

**RAG permitted:** `data_intensive_applications`, `domain_driven_design`, `enterprise_patterns`

**Architecture compliance:** Follows §6 of context_view.md.

---

### `migration-risk-analysis-skill`

**Purpose:** Classify the risk of proposed schema changes and produce a migration execution plan.

**When to use:**
- When a schema change is proposed (new table, column change, deletion)
- Before any migration is submitted to staging or production
- When revising a schema after Gate 2 feedback

**Inputs:**
- `Prisma_Schema_Proposal.prisma` or `DB_Schema.sql`
- Existing production schema (if available)
- `context_view.md` (§6.4–6.5 Migration Policy)

**Outputs:**
- Migration risk classification in `Risk_Register.md`
- Migration execution plan section in `Deployment_Strategy.md`

**Failure modes:**
- Underclassifying risk: treating a DROP COLUMN as LOW risk → use the phased plan when any data loss is possible
- Missing rollback consideration: not asking "what if this migration must be reversed?" → always classify as reversible/compatible/irreversible/destructive

**Quality gate:** Every proposed migration must have a risk classification and a corresponding rollback plan.

**RAG permitted:** `data_intensive_applications`, `architecture_reference_full`

**Architecture compliance:** Follows §6.5–6.6 of context_view.md.

---

### `architecture-tradeoff-analysis-skill`

**Purpose:** Formally analyze and document trade-offs for significant architectural decisions.

**When to use:**
- When evaluating competing architectural approaches
- When the Tech Lead Council is triggered for an architectural decision
- When a non-obvious trade-off exists between simplicity, performance, scalability, or maintainability

**Inputs:**
- Draft `Architecture.md` or specific decision under review
- `knowledge/heuristics.md`
- `knowledge/knowledge_cards.md`
- `knowledge/decision_rules.md`

**Outputs:**
- Trade-off analysis section in `Architecture.md` or `Architecture_Decisions.md`

**Failure modes:**
- Analysis without data: claiming performance benefits without concrete metrics → use "expected" framing and identify verification method
- Binary thinking: treating decisions as "right/wrong" instead of "trade-off space" → always document what is sacrificed

**Quality gate:** Every significant trade-off in the architecture must be documented with at least two alternatives and explicit consequences.

**RAG permitted:** `software_architecture_fundamentals`, `building_microservices`, `data_intensive_applications`

**Architecture compliance:** Follows §2 Architectural Principles of context_view.md.

---

### `observability-design-skill`

**Purpose:** Define the structured logging strategy, APM integration, and healthcheck requirements for the system.

**When to use:**
- During architecture design phase, before finalizing `Architecture.md`
- When a new service or significant integration is added
- When revising observability strategy after Security/DevOps feedback

**Inputs:**
- `Architecture.md` (component list)
- `context_view.md` (§9 Observability)
- `templates/Observability_Strategy.md`

**Outputs:**
- `Observability_Strategy.md`

**Failure modes:**
- Missing log fields: not defining structured log schema → specify every required field per component type
- No APM decision: leaving APM tooling undefined → choose from approved tools or flag for ADR
- PII in logs: designing log structures that include raw PII → always apply masking

**Quality gate:** `Observability_Strategy.md` must define log schema, APM tool, and healthcheck requirements.

**RAG permitted:** `architecture_reference_full`

**Architecture compliance:** Follows §9 of context_view.md.

---

### `security-architecture-skill`

**Purpose:** Produce a threat model and define security controls, data classification, auth/authz strategy, and audit logging requirements.

**When to use:**
- During architecture design, before finalizing `Architecture.md`
- When a new endpoint, integration, or data model is introduced
- When DevSecOps raises a security concern

**Inputs:**
- `Architecture.md` (draft)
- `API_Contract.json` (draft)
- `Prisma_Schema_Proposal.prisma` (draft)
- `context_view.md` (§8 Security)
- `templates/Security_Strategy.md`

**Outputs:**
- `Security_Strategy.md`
- Data classification notes (fed into `database-modeling-skill`)
- `audit_log` instrumentation requirements (fed into `observability-design-skill`)

**Failure modes:**
- Incomplete threat model: not asking all 5 mandatory threat modeling questions for each endpoint → run checklists/security_architecture_checklist.md
- Missing data classification: not identifying PII before modeling → block database-modeling-skill until classification is done
- Accepting CRITICAL risk alone: trying to self-approve a critical security risk → escalate to Tech Lead

**Quality gate:** Every endpoint must pass the 5 threat modeling questions. No CRITICAL security risk may proceed without human escalation.

**RAG permitted:** `architecture_reference_full`

**Architecture compliance:** Follows §8 of context_view.md.

---

### `deployment-strategy-skill`

**Purpose:** Define the deployment environments, migration execution strategy, Vercel Cron job requirements, rollback plan, and post-deploy validation criteria.

**When to use:**
- After `Architecture.md`, `DB_Schema`, and `API_Contract.json` are drafted
- When a new cron job or migration is introduced
- When DevOps raises a deployment concern

**Inputs:**
- `Architecture.md` (components, cron jobs identified)
- `Prisma_Schema_Proposal.prisma` (migration needs)
- `context_view.md` (§11 Deployment)
- `templates/Deployment_Strategy.md`

**Outputs:**
- `Deployment_Strategy.md`
- Rollback plan section (input for Gate 6 pre-requisite)

**Failure modes:**
- Missing rollback: producing a deploy strategy without a rollback plan → Gate 6 will be blocked; address now
- Wrong migration command: specifying `prisma db push` for staging/prod → always `prisma migrate deploy`
- Missing healthcheck: not defining `/api/health` requirements → required for every project

**Quality gate:** `Deployment_Strategy.md` must include environments, migration policy, rollback plan, and healthcheck definition.

**RAG permitted:** `architecture_reference_full`

**Architecture compliance:** Follows §11 of context_view.md.
