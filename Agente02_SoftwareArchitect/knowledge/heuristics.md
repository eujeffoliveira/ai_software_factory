# Heuristics — Agente02_SoftwareArchitect

_Practical decision heuristics distilled at build-time. Runtime: read-only._

---

## H1 — If the architecture is not explainable in 5 minutes, it is too complex

A good architecture can be described at the component level in a short conversation. If the explanation requires extensive preamble about how the framework works, the architecture is likely over-engineered.

**Use when:** Reviewing Architecture.md draft. If you cannot summarize it simply, simplify it.

---

## H2 — Name things what they are in the business domain

The word "item", "record", "data", "object", or "entity" in a model name is a signal of insufficient domain thinking. Every model should have a name that a business stakeholder would recognize.

**Use when:** Naming Prisma models, API endpoints, and TypeScript types.

---

## H3 — An aggregate boundary is defined by what must be consistent together

Two entities belong to the same aggregate if they must always be updated in the same transaction to maintain invariants. Two entities belong to separate aggregates if they can be updated independently.

**Use when:** Deciding whether to nest entities in a schema or link them by foreign key.

---

## H4 — A Server Component can do what a Route Handler used to do

In Next.js 16, most data fetching belongs in Server Components, not in API routes. If you are designing a Route Handler for initial page load data, question whether a Server Component is sufficient.

**Use when:** Deciding whether an API endpoint is necessary.

---

## H5 — Choose consistency over availability for financial and user-permission data

Data that controls access, money, or user state must be strongly consistent. AP systems (available and partition-tolerant) are appropriate for analytics, feeds, and non-critical reads — not for auth state or financial records.

**Use when:** Designing the database strategy for sensitive domains.

---

## H6 — If the schema can change without a migration, it should

When using `schema-on-read` (JSON blobs, JSONB columns), consider whether structured migrations would serve the use case better. JSONB is a valid escape hatch for truly dynamic data; it is not a substitute for proper relational modeling.

**Use when:** Tempted to use JSONB for data that has a stable, known structure.

---

## H7 — The upsert pattern eliminates most idempotency problems

When designing jobs or mutations that may run multiple times, design with `upsert` (insert or update) on a natural key. This eliminates most race conditions and retry problems without needing distributed locks.

**Use when:** Designing any job or batch operation that touches existing data.

---

## H8 — Architecture characteristics (fitness functions) reveal trade-offs

When evaluating two architectural options, list the architecture characteristics each supports: availability, scalability, maintainability, security, testability, deployability. The option with the better fit for the PRD's non-functional requirements is correct.

**Use when:** Running `architecture-tradeoff-analysis-skill`.

---

## H9 — The "strangler fig" is the safe migration pattern

When migrating away from legacy patterns, strangle incrementally: add new functionality alongside old, migrate traffic gradually, remove old code only when new code is proven. Never do a big-bang rewrite.

**Use when:** Architecture involves replacing an existing system or pattern.

---

## H10 — Cohesion is more important than decoupling at the start

Early-stage SaaS applications suffer more from fragmentation than from coupling. Start with high cohesion (related things together) and introduce decoupling only when a specific pain point emerges.

**Use when:** Tempted to separate concerns "just in case" without a current PRD requirement.

---

## H11 — ADR prevents architectural amnesia

Decisions made today that are not documented become "legacy decisions" that no one can explain. An ADR takes 15 minutes to write and saves days of debugging the "why" in the future.

**Use when:** Any decision that might be questioned 6 months later. If in doubt, write the ADR.

---

## H12 — Microservices are the end state, not the starting state

Microservices require operational maturity: CI/CD per service, distributed tracing, service mesh, independent deployments. Starting with microservices before achieving monolith maturity creates distributed complexity without the benefits.

**Use when:** A stakeholder proposes microservices from day one. Propose a modular monolith first and plan the extraction path.

---

## H13 — Service decomposition should follow the "seam" of different change rates

Two modules that change at different rates for different reasons are candidates for service decomposition. Modules that change together should stay together.

**Use when:** Evaluating whether to split a feature into a separate service.

---

## H14 — Repository pattern is correct for Prisma DAL

Use the Repository pattern (lib/db/[domain].ts) to isolate database access from business logic. This enables testing without a real database and simplifies future ORM migrations.

**Use when:** Designing the Data Access Layer structure.

---

## H15 — Data Mapper (Prisma) is preferred over Active Record for complex domains

Active Record (data object knows how to save itself) works for simple CRUD. For complex domains with business rules, Data Mapper (separate persistence layer) keeps domain logic pure.

**Use when:** Deciding whether to put business logic in Prisma model callbacks or in service functions.

---

## H16 — Use case diagrams reveal missing actors before the architecture is committed

Before finalizing the component diagram, draw a use case diagram. Every actor in the use case diagram maps to an entry point in the architecture (a user-facing route, an external integration, or an internal agent). Missing an actor at this stage means missing a system boundary.

**Trigger:** Before finalizing Architecture.md system components section.  
**Action:** Draw UC diagram, count actors, verify each actor has a corresponding entry-point component in architecture.

---

## H17 — Sequence diagrams expose coupling that class diagrams hide

A class diagram shows that two classes are related. A sequence diagram shows how many messages they exchange to complete a single use case. High message density between two components in a sequence diagram = tight coupling that the static diagram conceals. If a sequence diagram has more than 5 back-and-forth messages between two components, redesign the interaction.

**Trigger:** After drawing component diagram, before finalizing API contracts.  
**Action:** Trace each use case through the sequence diagram. If component pair exchanges > 5 messages: consider redesigning with an intermediate layer or event-driven handoff.

---

## H18 — Class diagrams must reflect domain language from the PRD

Class names, attribute names, and method names in the domain layer must use the exact vocabulary from the PRD. Any discrepancy between PRD terminology and model naming is a violation of P5 (Ubiquitous Language) and must be resolved before Architecture.md is submitted.

**Trigger:** When reviewing class diagram against PRD.  
**Action:** Verify every domain class name and attribute name appears with the same meaning in the PRD or has been formally renamed through a terminology alignment.
