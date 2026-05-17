# Good Output — adr-authoring-skill

## Scenario

The PRD requires an AI-powered resume scoring feature (NFR-05: scoring must complete in < 2 seconds, FR-12: score resumes against job descriptions using LLM). The Golden Path has no precedent for Python/FastAPI microservices, which is a listed deviation category.

## Produced ADR

**File:** `docs/adr/ADR-004-use-python-fastapi-for-ai-scoring-service.md`

---

# ADR-004: Use Python/FastAPI for AI Scoring Microservice

**Status:** PROPOSED  
**Date:** 2026-05-17  
**PRD Requirement:** FR-12, NFR-05  
**Triggers gate:** 2

## Context

The PRD requires LLM-based resume scoring against job descriptions (FR-12) with a P95 latency target of < 2 seconds (NFR-05). The Golden Path stack (Next.js 16 / TypeScript) has no mature LLM inference libraries and would require bridging via REST anyway. The Vercel edge runtime has a 30-second function timeout ceiling that is insufficient for batch scoring jobs involving multi-turn LLM calls with large context windows. A dedicated inference service is necessary to meet the latency NFR without blocking the main web server.

## Decision

We will introduce a Python/FastAPI microservice deployed on Railway for LLM inference, called from Next.js Server Actions via a typed REST client in `lib/integrations/scoring-service.ts`.

## Alternatives Considered

### Alternative 1 (chosen): Python/FastAPI on Railway
- Considered because: Python has mature LLM tooling (LangChain, OpenAI SDK, llama-index) and the team already has Python expertise
- Chosen because: meets NFR-05 latency target; Railway supports auto-scale; Python's async model suits LLM streaming

### Alternative 2: Next.js API route calling OpenAI directly
- Considered because: stays in Golden Path, zero new infrastructure
- Rejected because: Vercel function timeout (30s) conflicts with batch scoring (NFR-05 batch mode requires up to 120s); no streaming support in route.ts pattern

### Alternative 3: Vercel AI SDK in Next.js
- Considered because: officially supported Vercel tooling, stays in-platform
- Rejected because: Vercel AI SDK streaming conflicts with the thin-shell route.ts rule; would push LLM logic into route handlers, violating §5.2; also still subject to 30s timeout on pro tier

## Consequences

**Positive:**
- Meets NFR-05 latency and batch timeout requirements
- Python LLM ecosystem is more mature; easier to iterate on prompting strategies
- Scoring service can be independently scaled without affecting web tier

**Negative:**
- Introduces a second language (Python) into the repository — increases cognitive overhead
- Railway is not in the Golden Path — requires ADR approval and ongoing ADR governance
- Typed REST client must be maintained in sync with FastAPI schemas (Zod validation required on Next.js side)

**Risks:**
- RISK-007: Railway outage causes scoring feature unavailability — mitigated by graceful degradation fallback in UI

---

## Why this is a good output

- Status is `PROPOSED` — not self-approved
- 3 alternatives documented (exceeds minimum of 2), all with explicit rejection rationale
- Decision starts with "We will…"
- Both positive AND negative consequences listed
- PRD requirement IDs cited (FR-12, NFR-05)
- Filename follows pattern: `ADR-004-use-python-fastapi-for-ai-scoring-service.md`
- Architecture_Decisions.md entry: `ADR-004: Use Python/FastAPI for AI Scoring Microservice | Status: PROPOSED | Triggers gate: 2`
