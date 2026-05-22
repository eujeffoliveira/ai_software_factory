# Rubric — Software Architect (@architect / Agente02)

## Scoring Guide

0 = Absent or completely wrong — the dimension is not addressed or the answer is incorrect
1 = Partial — present but incomplete, missing key elements, or partially wrong
2 = Correct but missing nuance — technically accurate but lacks depth, specificity, or edge case handling
3 = Excellent — complete, accurate, contextually appropriate, and demonstrates mastery of the rule

---

## Dimensions

### 1. Golden Model Compliance
**Weight:** HIGH

**Score 3:** Selects all components from the correct Golden Model for the classified archetype. For web_app: Next.js 16 (App Router), React 19, TypeScript 5, Tailwind CSS v4, NextAuth v5, Supabase/PostgreSQL, Prisma 7 with PrismaPg, Vercel, Zod at all boundaries, Vitest + Playwright. Explicitly avoids forbidden patterns (middleware.ts, Pages Router, prisma db push in staging/prod). Each component choice is justified.

**Score 2:** Correct Golden Model applied but one component is missing from the recommendation (e.g., Zod omitted, or deployment target not specified). No forbidden patterns present.

**Score 1:** Mostly correct Golden Model but one component is wrong or replaced with an alternative without an ADR (e.g., uses Drizzle instead of Prisma). Or a forbidden pattern is present.

**Score 0:** Wrong Golden Model applied entirely (e.g., Python/FastAPI for a web_app project). Or multiple wrong component selections without ADRs.

---

### 2. ADR for Deviations
**Weight:** HIGH

**Score 3:** Any deviation from the Golden Model is accompanied by a formal ADR reference (ADR-NNN) or an inline ADR structure with: context, decision, consequences, and alternatives considered. The ADR is technically sound — the deviation is justified by real constraints, not preference.

**Score 2:** Deviation acknowledged but ADR is incomplete — missing consequences or alternatives considered. Or deviation is technically justified but the ADR structure is informal.

**Score 1:** Deviation present and author is aware of it but provides only a sentence of justification, not a structured ADR. Shows awareness that a deviation requires documentation.

**Score 0:** Deviation from Golden Model with no acknowledgment and no ADR. Agent presents a non-standard choice as if it were the standard.

---

### 3. Security Strategy
**Weight:** HIGH

**Score 3:** Addresses all four security layers: authentication (NextAuth session), authorization (server-side ownership checks before every data access), input validation (Zod at all entry points), error handling (generic messages to clients, no stack traces exposed). Explicitly mentions where auth checks occur (before DAL calls, not after). Notes the IDOR prevention pattern.

**Score 2:** Three of four security layers addressed. Or all four addressed but one is incomplete (e.g., mentions Zod but does not specify "at all entry points").

**Score 1:** One or two security layers addressed. Missing the ownership check pattern or missing input validation strategy.

**Score 0:** No security strategy. Or security strategy limited to "we'll add auth" with no specifics.

---

### 4. Observability Plan
**Weight:** MEDIUM

**Score 3:** Defines both logging types: audit_log (for human-initiated actions — who did what and when) and sync_log (for automated jobs — start time, end time, records processed, errors). Specifies structured JSON log format. Notes that internal errors must not be exposed to clients. Mentions at least one monitoring or alerting integration.

**Score 2:** Both log types mentioned but without structural detail (no schema, no format specification). Or only one log type defined.

**Score 1:** Generic "we'll use logging" mention. No distinction between audit and operational logs. No format specification.

**Score 0:** No observability plan. Logs not mentioned at all.

---

### 5. API Contract Quality
**Weight:** HIGH

**Score 3:** API contract covers all endpoints with: HTTP method, path, authentication requirement, request body schema (Zod), response body schema (Zod), and error response format. Every protected endpoint explicitly notes auth requirement. Error format is `{ error: "string" }` consistently. No endpoint has ambiguous behavior.

**Score 2:** API contract covers all endpoints but missing some fields — e.g., no error response schema for some endpoints, or auth requirement implied but not stated.

**Score 1:** API contract covers the main happy-path endpoints but omits error responses, or omits some endpoints entirely.

**Score 0:** No API contract. Or API contract is informal prose with no schema definitions.

---

### 6. Database Schema Correctness
**Weight:** HIGH

**Score 3:** Schema covers all entities from the PRD. Every entity has appropriate fields including: id (UUID or CUID), createdAt, updatedAt. Relationships are correctly modeled (1:N, M:N with junction tables). Foreign key constraints are explicit. Indexes are specified for frequently queried fields. Soft delete pattern used where appropriate (deletedAt).

**Score 2:** All entities present. Relationships correct. Missing some infrastructure fields (timestamps, indexes) or missing soft delete consideration.

**Score 1:** Main entities present but relationships incomplete or incorrect. Missing foreign key modeling.

**Score 0:** Schema absent or wrong — missing core entities from the PRD, or incorrect relationship direction.

---

### 7. Testing Strategy
**Weight:** MEDIUM

**Score 3:** Defines the test pyramid explicitly (unit/Vitest, integration/Vitest, E2E/Playwright). Specifies minimum test case requirements for Server Actions (4 cases: unauth, invalid input, success, error). Specifies Playwright for golden-path E2E flows. Specifies accessible selectors policy (getByRole, getByLabel — no CSS/XPath). Coverage thresholds (80% new logic, 100% auth paths).

**Score 2:** Test pyramid mentioned and both frameworks named but without specifics on coverage thresholds or test case minimums. Or E2E strategy defined but no unit test strategy.

**Score 1:** "We'll use Vitest and Playwright" with no further specification. No coverage requirements, no test case minimums, no selector policy.

**Score 0:** No testing strategy. Or recommends wrong testing frameworks (Jest, Cypress, Selenium).

---

## Aggregate Score Interpretation

**Maximum score:** 21 (7 dimensions x 3)

| Total Score | Interpretation |
|-------------|----------------|
| 19–21 | Excellent — architecture document is production-ready |
| 15–18 | Good — minor gaps; request clarification or revision on low-scoring dimensions |
| 10–14 | Acceptable — notable gaps; at least one HIGH dimension needs revision before Gate 2 passes |
| 5–9 | Poor — multiple HIGH dimensions failing; architecture needs significant rework |
| 0–4 | Failing — architecture does not meet the minimum standard for gate advancement |

**Critical failures (override the score):** A score of 0 on Golden Model Compliance or Security Strategy should be treated as an automatic Gate 2 BLOCK — these represent fundamental architectural failures that create downstream risk across all subsequent gates.
