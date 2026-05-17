# Example: Good ADR

---

# ADR-001 — Use Python/FastAPI Service for AI Resume Parsing

## Status

Proposed

## Date

2026-05-17

## Context

The PRD (FR-12) requires automatic parsing of uploaded PDF resumes to extract structured candidate data (name, skills, experience years, contact information). The accuracy target is ≥ 90% extraction accuracy on standard PDF formats.

Initial evaluation shows that JavaScript-based PDF parsing libraries (pdf-parse, pdfjs-dist) achieve ~65% accuracy on complex PDF layouts. Achieving ≥ 90% accuracy requires ML-based extraction using Python libraries (spaCy, transformers) that are not available in the Node.js ecosystem.

The current architecture is a Next.js 16 fullstack monorepo. Adding this ML capability requires a language and runtime incompatible with the Golden Path.

## Decision

We will add a dedicated Python/FastAPI service (`services/ai-parser/`) responsible exclusively for PDF ingestion and structured data extraction. The Next.js application will call this service via an internal HTTP API after PDF upload. The service will be containerized and deployed on [Cloud Run / Railway — TBD by DevOps].

## Deviation from Golden Path

**Deviates from Golden Path:** Yes  
**Golden Path item affected:** "fullstack-monorepo on Next.js — no separate services"  
**Reason deviation is justified:** JavaScript ecosystem cannot satisfy FR-12's ≥ 90% accuracy requirement without Python ML libraries.

## Alternatives Considered

| Alternative | Pros | Cons |
|-------------|------|------|
| Python/FastAPI service (chosen) | Meets accuracy target; isolated scope; independent deployment | Adds operational complexity; second deployment unit; Python expertise required |
| JavaScript-only parsing | No new service; simpler ops | Only 65% accuracy — fails PRD requirement FR-12 |
| Third-party SaaS API (e.g., Affinda) | No engineering effort | Ongoing cost ($0.50/resume); PII sent to third party — data protection compliance concern |

## Consequences

**Technical impact:** Second architecture quantum; inter-service HTTP call; error handling for service unavailability; request timeout management.

**Operational impact:** Second deployment pipeline; separate containerization; monitoring for Python service; on-call runbook addition.

**Financial impact:** Hosting cost for Python service (~$20-50/month on Cloud Run). Validated as acceptable vs. $0.50/resume SaaS cost at projected volume.

**Maintenance impact:** Requires Python proficiency in team; dependency on Python ML libraries that evolve rapidly.

**Security/compliance impact:** Resume PDF data (PII) processed internally — does not leave our infrastructure. Compliant with data protection requirements.

## Review Criteria

Re-evaluate if: (a) JavaScript ML libraries improve to meet 90% accuracy target, or (b) monthly volume exceeds 10,000 resumes/month (reassess cost vs. SaaS).
