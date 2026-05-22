# Decision Rules — Agente02_SoftwareArchitect

_Actionable if-then rules distilled at build-time. Runtime: read-only._

---

## DR001 — Golden Path Enforcement

**IF** an architectural decision uses a technology, pattern, or tool not in the Golden Path  
**THEN** invoke `adr-authoring-skill` and set gate status to `BLOCKED_PENDING_ADR`.

**Applies to:** Any technology selection in Architecture.md.  
**Source:** Reference Architecture §3.3.

---

## DR002 — Architecture Style Selection

**IF** the PRD describes a standard SaaS application with < 1M users  
**THEN** use the Golden Path (Next.js 16 fullstack monorepo on Vercel).

**IF** the PRD describes workloads requiring dedicated compute (long-running jobs, real-time WebSockets, AI inference)  
**THEN** propose a dedicated service via ADR, keeping the monorepo as the primary application.

**Source:** Reference Architecture §5, Building Microservices (Newman), Fundamentals of SW Architecture (Richards & Ford).

---

## DR003 — Use Case Traceability Requirement

**IF** an architectural component, pattern, or layer is proposed  
**THEN** it must trace to at least one non-functional requirement or business use case in the PRD.

**IF** no traceability exists  
**THEN** remove the component.

**Source:** Clean Architecture — Martin; Reference Architecture §2.P1.

---

## DR004 — Bounded Context Isolation

**IF** a domain entity has different attributes, rules, or meanings in different parts of the system  
**THEN** define separate models for each context and connect them only via explicit interfaces.

**IF** two models always change together and share the same invariants  
**THEN** they belong to the same aggregate (same model).

**Source:** Domain-Driven Design — Evans.

---

## DR005 — API Contract Completeness

**IF** an endpoint appears in Architecture.md  
**THEN** it must appear in `API_Contract.json` with: method, path, auth requirement, request schema, response schema, and error codes.

**IF** an endpoint in `API_Contract.json` implies business logic in route.ts  
**THEN** redesign: move logic to `lib/` and keep route.ts as a thin shell.

**Source:** Reference Architecture §5.2–5.3.

---

## DR006 — Component Coupling Detection

**IF** two modules change together more than 80% of the time  
**THEN** they are candidates for consolidation into the same module.

**IF** two modules have zero shared change  
**THEN** they are candidates for loose coupling (event-driven or explicit interface).

**Source:** Fundamentals of Software Architecture — Richards & Ford.

---

## DR007 — Database Technology Selection

**IF** the data is relational with known schema  
**THEN** use PostgreSQL on Supabase via Prisma 7 (Golden Path).

**IF** the data is document-structured with truly dynamic schema  
**THEN** evaluate JSONB column in PostgreSQL first; propose MongoDB only via ADR if JSONB is insufficient.

**IF** the data is time-series or append-only metrics  
**THEN** evaluate whether PostgreSQL + partitioning suffices before proposing a dedicated time-series DB (ADR required).

**Source:** Reference Architecture §10; Designing Data-Intensive Applications — Kleppmann.

---

## DR008 — Consistency Model Selection

**IF** data represents financial state, user permissions, or auth state  
**THEN** design for strong consistency (ACID transactions, no eventually consistent reads for decisions).

**IF** data represents analytics, feeds, or non-critical aggregates  
**THEN** eventual consistency is acceptable.

**Source:** Designing Data-Intensive Applications — Kleppmann (Chapters on Consistency).

---

## DR009 — Migration Risk Classification

**IF** a migration adds a nullable column, creates a new table, or adds an index  
**THEN** classify as REVERSIBLE — standard deployment.

**IF** a migration adds a NOT NULL column with a backfill  
**THEN** classify as COMPATIBLE — phase 1: add nullable, phase 2: backfill, phase 3: add NOT NULL.

**IF** a migration renames or removes a column/table  
**THEN** classify as IRREVERSIBLE — requires human approval and phased deploy.

**IF** a migration drops data without recovery  
**THEN** classify as DESTRUCTIVE — requires formal plan, backup, and human approval.

**Source:** Reference Architecture §10.5–10.6.

---

## DR010 — When to Propose a Dedicated Service

**IF** a job runs longer than 60 seconds regularly  
**THEN** propose a dedicated worker service via ADR.

**IF** a use case requires persistent WebSocket connections  
**THEN** propose a dedicated containerized service via ADR.

**IF** a use case involves AI inference or ML model serving  
**THEN** propose a Python/FastAPI service via ADR.

**IF** a use case requires a reliable message queue with dead-letter  
**THEN** propose a queue (Redis/BullMQ or similar) via ADR.

**Source:** Reference Architecture §5.5; Building Microservices — Newman.

---

## DR011 — When NOT to Propose a Dedicated Service

**IF** the requirement can be satisfied by Vercel Cron + standard Next.js route  
**THEN** stay in the monorepo.

**IF** the separation would require inter-service communication for a simple CRUD operation  
**THEN** it is premature decomposition — stay in the monorepo.

**Source:** Building Microservices — Newman (Chapter: When Not to Use Microservices).

---

## DR012 — DAL Pattern Enforcement

**IF** a database query is needed  
**THEN** place it in `lib/db/[domain].ts` (Repository pattern) — never in route.ts, Server Actions, or components.

**IF** a mutation requires auditing  
**THEN** the Repository function must call `logAudit()` after the write operation.

**Source:** Patterns of Enterprise Application Architecture — Fowler; Reference Architecture §5.2.

---

## DR013 — Security by Default

**IF** an endpoint does not explicitly require anonymous access  
**THEN** design it as protected (requires auth) by default.

**IF** an endpoint modifies data, permissions, or sensitive state  
**THEN** require explicit authorization check (role + status) in addition to authentication.

**IF** a data field contains PII  
**THEN** classify it, minimize it, and ensure it is never logged in plain text.

**Source:** Reference Architecture §8.

---

## DR014 — Cron Security

**IF** a route is a cron job entry point  
**THEN** it must call `guardCron()` as the first operation before any business logic.

**Source:** Reference Architecture §12.

---

## DR015 — Escalation Triggers

**IF** a risk is classified as CRITICAL and cannot be mitigated at architecture level  
**THEN** set `gate_status` to `BLOCKED_PENDING_RISK_MITIGATION` and include in escalation request.

**IF** an ADR requires accepting a new significant operational cost  
**THEN** escalate to Tech Lead for human approval before PROPOSED status.

**IF** a migration is classified as DESTRUCTIVE  
**THEN** escalate to Tech Lead for explicit human approval before Gate 6.

**Source:** Reference Architecture §20 Tech Lead Council; integrantes.md §AGENTE 02 §12.

---

## UML and Design Modeling Rules

## DR016 — IF Architecture.md lacks a sequence diagram for the primary use case THEN the architecture is not reviewable — add before Gate 2 submission

## DR017 — IF a class in the domain model cannot be traced to a noun in the PRD THEN the class is likely an implementation artifact — move to infrastructure layer or remove

## DR018 — IF a use case diagram actor has no corresponding system entry-point (route, webhook, cron) in Architecture.md THEN the architecture is missing a component — add before Gate 2

## DR019 — IF a sequence diagram shows >5 messages between the same two components for one use case THEN coupling is excessive — redesign with a mediator, service, or event

## DR020 — IF cohesion analysis shows a component has >3 independent reasons to change THEN split component — single responsibility must hold at the architectural component level

---

## Archetype Classification Rules

DR-CLASS-001: Before applying any Golden Model, classify the project using the Project Archetype Matrix in `standards/project-classification.md`. The archetype determines which Golden Model applies.

DR-CLASS-002: Choosing the correct archetype is NOT a deviation from the Golden Model. No ADR is required for archetype selection. ADRs are only required for deviations *within* a chosen archetype.

DR-CLASS-003: `web_app` archetype → apply `standards/golden-model-web-app.md` (Next.js 16 stack). This is the default for user-facing applications.

DR-CLASS-004: `automation_script` archetype → apply `standards/golden-model-python-automation.md` (Python 3.12+ + uv + Typer + Pydantic v2 + structlog). Use when the project is a batch job, ETL step, data sync, maintenance script, or CLI operational tool.

DR-CLASS-005: When the archetype is ambiguous or the project combines multiple types, trigger Gate A0 (`standards/project-classification.md`) before proceeding. Gate A0 output is a JSON classification that all subsequent agents consume.
