# Knowledge Cards — Agente02_SoftwareArchitect

_Reusable concept cards distilled at build-time. Runtime: read-only._

---

### Card 001 — The Dependency Rule (Clean Architecture)

**Concept:** Source code dependencies must always point inward, toward the domain/use case layer. Outer layers (frameworks, databases, UI) depend on inner layers — never the reverse.

**Layers (outer → inner):**
```
Frameworks & Drivers (Next.js, Prisma, NextAuth)
  → Interface Adapters (route.ts, Server Actions, lib/db)
    → Application Use Cases (features/[domain]/[domain].service.ts)
      → Domain Entities (features/[domain]/[domain].types.ts)
```

**Golden Path mapping:**
- `app/api/**/route.ts` = Interface Adapter (thin shell)
- `features/*/service.ts` = Application Use Case
- `types/*.ts` = Domain Entities
- `lib/db/*.ts` = Interface Adapter (data access)

**Source:** Clean Architecture — R.C. Martin

---

### Card 002 — SOLID Principles Applied to Architecture

**Single Responsibility:** Each module/service has exactly one reason to change.  
**Open/Closed:** Modules are open for extension (new features), closed for modification (stable interface).  
**Liskov Substitution:** Subtypes must be substitutable for their base types (critical for TypeScript interfaces).  
**Interface Segregation:** Clients should not depend on interfaces they don't use (keep interfaces small and focused).  
**Dependency Inversion:** Depend on abstractions, not concretions (depend on TypeScript interfaces, not implementations).

**Source:** Clean Architecture — R.C. Martin

---

### Card 003 — Component Cohesion Principles

**REP (Reuse/Release Equivalence):** Things that are reused together should be released together.  
**CCP (Common Closure):** Classes/modules that change for the same reason should be grouped together.  
**CRP (Common Reuse):** Don't force users of a component to depend on things they don't need.

**Application:** Use CCP when deciding what goes in a `feature/[domain]/` folder. If two modules always change together, they belong together.

**Source:** Clean Architecture — R.C. Martin

---

### Card 004 — Bounded Context

**Definition:** A bounded context is the boundary within which a particular domain model applies. The same real-world concept (e.g., "user") may have different models in different contexts (auth context vs. billing context vs. notification context).

**Signs you need a bounded context split:**
- The same entity name means different things to different teams
- Two modules share a model but use only 30% of its fields
- A change to the shared model always breaks one or both consumers

**Golden Path mapping:** In a Next.js monorepo, bounded contexts map to `features/[domain]/` folders with their own types, schemas, services, and repositories.

**Source:** Domain-Driven Design — Eric Evans

---

### Card 005 — Aggregate Root

**Definition:** An aggregate is a cluster of domain objects (entities and value objects) that can be treated as a single unit. The aggregate root is the only object through which the aggregate is accessed from outside.

**Rules:**
- External objects may reference only the aggregate root by ID
- Transactions do not cross aggregate boundaries
- Each aggregate is the unit of consistency

**Example in Golden Path:**
```
Order (aggregate root)
  → OrderItem (entity, part of Order aggregate)
  → ShippingAddress (value object, part of Order aggregate)
  → CustomerId (reference by ID to Customer aggregate — different aggregate)
```

**Source:** Domain-Driven Design — Eric Evans

---

### Card 006 — CAP Theorem

**Definition:** A distributed system can guarantee at most two of three properties:
- **C**onsistency: Every read receives the most recent write
- **A**vailability: Every request receives a response
- **P**artition tolerance: The system continues operating despite network partitions

**For the Golden Path (PostgreSQL on Supabase):** CP system — consistency and partition tolerance. Favors correctness over availability during network issues.

**Decision rule:** For financial, permission, and auth data: CP (PostgreSQL). For analytics/feeds: AP is acceptable.

**Source:** Designing Data-Intensive Applications — Kleppmann

---

### Card 007 — ACID vs. BASE

**ACID** (Atomicity, Consistency, Isolation, Durability): Traditional relational database guarantees. PostgreSQL/Prisma provides full ACID compliance.

**BASE** (Basically Available, Soft-state, Eventually consistent): Used in NoSQL and distributed systems. Sacrifices immediate consistency for availability and performance.

**Golden Path decision:** Use ACID (PostgreSQL) for all business data. BASE/eventual consistency is only acceptable for cached analytics or non-critical aggregates.

**Source:** Designing Data-Intensive Applications — Kleppmann

---

### Card 008 — Schema-on-Read vs. Schema-on-Write

**Schema-on-write:** Structure is enforced at write time (relational DB, Prisma schema). More rigid but guarantees data quality. Better for known, stable structures.

**Schema-on-read:** Structure is interpreted at read time (document DB, JSONB). More flexible but defers validation. Better for truly dynamic or evolving structures.

**Golden Path decision:** Always prefer schema-on-write (Prisma schema). Use JSONB columns only when the data structure is genuinely dynamic and a relational schema would change too frequently.

**Source:** Designing Data-Intensive Applications — Kleppmann

---

### Card 009 — Anti-Corruption Layer (ACL)

**Definition:** A translation layer that converts between two domain models or two bounded contexts, preventing concepts from one context from "corrupting" the model of another.

**Use cases in Golden Path:**
- Integration with external APIs (TOTVS, Microsoft, Google): the integration client in `lib/integrations/` is an ACL
- Consuming events from external systems: transform external payload to internal domain types

**Source:** Domain-Driven Design — Eric Evans

---

### Card 010 — Architecture Characteristics (Fitness Functions)

**Definition:** Measurable properties of an architecture that define how well it satisfies non-functional requirements.

**Common characteristics:**
- **Scalability:** handles 10x load without redesign
- **Availability:** 99.9% uptime requirement
- **Maintainability:** time-to-understand for new developer
- **Testability:** percentage of code reachable by automated tests
- **Security:** OWASP compliance level
- **Deployability:** deployment frequency and lead time

**Application:** Map each PRD non-functional requirement to one or more architecture characteristics. Every component decision should optimize for the required characteristics.

**Source:** Fundamentals of Software Architecture — Richards & Ford

---

### Card 011 — Architecture Quantum

**Definition:** An independently deployable artifact with high functional cohesion. In a monorepo: the entire application is one quantum. In a microservices system: each service is a quantum.

**Significance:** The number of architecture quanta defines the operational complexity. One quantum = simpler operations. Multiple quanta = distributed system problems.

**Golden Path decision:** Start with one quantum (monorepo). Add a second quantum only via ADR when a clear quantum-split justification exists (different scaling needs, different tech requirements, different deployment cadence).

**Source:** Fundamentals of Software Architecture — Richards & Ford

---

### Card 012 — Service Decomposition Patterns (Microservices)

**Decompose by business capability:** Each service owns a business function (payments, notifications, users). This is the recommended pattern.

**Decompose by subdomain (DDD):** Each service corresponds to a DDD bounded context. Aligns well with DDD strategic design.

**Anti-pattern — Decompose by technical tier:** Auth service, database service, API service. Creates distributed monolith — all services change together.

**Source:** Building Microservices — Sam Newman

---

### Card 013 — Strangler Fig Pattern

**When to use:** Migrating from a legacy system or replacing an existing architectural pattern.

**How it works:**
1. New functionality is built in the new architecture
2. Existing functionality is migrated incrementally
3. Old code is removed only when fully replaced

**Golden Path application:** When replacing a Next.js 15 pattern with Next.js 16 pattern (e.g., middleware.ts → proxy.ts), use the strangler fig: add proxy.ts, migrate routes gradually, remove middleware.ts last.

**Source:** Building Microservices — Sam Newman

---

### Card 014 — Repository Pattern

**Definition:** A collection-like interface that abstracts all database access. Callers work with domain objects; the repository handles SQL/ORM details.

**Golden Path implementation:**
```
features/[domain]/[domain].repository.ts
  - findById(id: string): Promise<Domain | null>
  - findAll(filter: Filter): Promise<Domain[]>
  - create(data: CreateInput): Promise<Domain>
  - update(id: string, data: UpdateInput): Promise<Domain>
  - delete(id: string): Promise<void>
```

**Benefits:** Testable without a database (mock the repository), ORM-agnostic domain logic, single responsibility.

**Source:** Patterns of Enterprise Application Architecture — Fowler

---

### Card 015 — Unit of Work

**Definition:** Maintains a list of objects affected by a business transaction and coordinates the writing out of changes and the resolution of concurrency problems.

**Prisma implementation:** `prisma.$transaction()` is the Unit of Work pattern. Use it for operations that must succeed or fail together (2–4 related writes).

**Warning:** Do not use `$transaction()` for long operations or operations involving external API calls.

**Source:** Patterns of Enterprise Application Architecture — Fowler

---

### Card 016 — Service Layer

**Definition:** Defines the application's boundary with a layer of services that establishes a set of available operations and coordinates the application's response in each operation.

**Golden Path mapping:**
```
features/[domain]/[domain].service.ts = Service Layer
  - Orchestrates use cases
  - Calls repository for data access
  - Applies business rules
  - Calls lib/email, lib/integrations as needed
  - Does NOT handle HTTP request/response (that's the interface adapter)
```

**Source:** Patterns of Enterprise Application Architecture — Fowler
