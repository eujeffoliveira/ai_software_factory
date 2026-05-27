# Non-Functional Requirements Skill

## Purpose
Identify and document NFRs across all 10 mandatory categories with measurable metrics derived from the business context, scale expectations, and compliance requirements.

## When to Use
- When PRD functional sections are complete and the NFR section needs to be drafted before PRD assembly.
- When NFRs are returned at Gate 1 for missing metrics or missing categories.

## Inputs
- `business_problem` — confirmed business problem and context
- `target_users` — user personas with scale expectations
- `scale_expectations` — expected user volume, data volume, and growth rate
- `compliance_context` — known regulatory requirements (privacy laws, accessibility standards, industry regulations)

## Outputs
- `Non_Functional_Requirements.md` — all 10 categories with measurable metrics using `templates/Non_Functional_Requirements.md` format. Each individual NFR entry must include:
  - `id` — in the form `NFR-[CATEGORY]-[NNN]` (e.g., `NFR-PERFORMANCE-001`)
  - `name` — short descriptive label
  - `metric` — the measurable statement (what is being measured)
  - `threshold` — the specific value, percentile, or range (e.g., "P95 ≤ 2s at 500 concurrent users")
  - `justification` — how this threshold was derived from inputs (scale expectations, compliance, business criticality)
  - `owner` — the role responsible for meeting this NFR

## Constraints
- Every NFR must have a measurable metric — no vague statements accepted
- All 10 categories are mandatory and **must appear as sections** in the output document: performance, security, privacy, availability, observability, auditability, accessibility, maintainability, scalability, data retention. A document with fewer than 10 sections fails Gate 1.
- If a category has no applicable NFR (rare), document `N/A — [specific reason why this category does not apply]` as the section content. The section must still exist — marking N/A counts as a present section, not a missing one.
- Performance metrics must specify a percentile (P50, P95, P99) — not just "average"
- Privacy NFRs must identify specific PII fields by name — not "personal data" generically
- NFRs must not contain technology decisions (no database names, no framework names)

## Step-by-Step Procedure

1. **Performance.** Identify the primary user-facing operations (page loads, form submissions, searches). Set P95 thresholds based on scale expectations. Typical baseline: P95 ≤ 2s for interactive pages under expected concurrent load.

2. **Security.** Identify authentication model (who can access the system), authorization model (what each role can do), and sensitive operations. Specify HTTP status codes for unauthorized access.

3. **Privacy.** List all PII fields by name from the data requirements. Specify logging constraints (PII must not appear in plain-text logs). Identify consent or access control requirements.

4. **Availability.** Set uptime target based on business criticality. Typical SaaS baseline: 99.5% monthly. Define measurement period and planned maintenance exclusions.

5. **Observability.** Specify what events must be logged, the format (structured JSON), and delivery timing. Identify monitoring and alerting requirements.

6. **Auditability.** Identify which actions must be auditable (typically: all admin actions, all state changes to sensitive entities). Specify what each audit record must contain. Set retention period.

7. **Accessibility.** Reference a standard (WCAG 2.1 Level AA for web applications). Specify keyboard navigation requirements. State how compliance will be verified.

8. **Maintainability.** Specify code quality constraints (no circular dependencies between modules). Set test coverage threshold for business logic. Identify enforcement mechanism (CI lint rule, coverage gate).

9. **Scalability.** Set concurrent user target and data volume ceiling beyond which architectural changes would be needed. Base on scale_expectations input.

10. **Data Retention.** Specify retention period per entity type. Define deletion/archival policy. Reference any regulatory requirement that drives the period.

11. **Run `checklists/non_functional_requirements_checklist.md`.** Verify all 10 sections pass. Every NFR must have a metric before the document is declared complete.

## Knowledge Access Policy

**Allowed at runtime:**
- `Agente01_ProductOwner/knowledge/`
- `Agente01_ProductOwner/templates/`
- `Agente01_ProductOwner/checklists/`
- Project inputs provided by Tech Lead

**Blocked at runtime:**
- `context/`, `lib/`, raw PDFs, global documents
