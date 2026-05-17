# architecture-design-skill Checklist

## Pre-execution
- [ ] PRD.md is present and approved by Gate 1
- [ ] Open_Questions.md is available (or confirmed absent)
- [ ] context_view.md is loaded (Golden Model reference)

## During execution
- [ ] All PRD functional requirements mapped to components
- [ ] All PRD non-functional requirements mapped to architectural decisions
- [ ] Architecture style justified via PRD NFRs
- [ ] All mandatory layers present: proxy.ts, auth.ts, lib/env.ts, lib/db/, /api/health
- [ ] No business logic in route.ts
- [ ] No middleware.ts (Next.js 16 uses proxy.ts)
- [ ] Deviations identified for ADR

## Post-execution
- [ ] architecture_quality_checklist.md passed
- [ ] golden_path_compliance_checklist.md run
- [ ] Assumptions documented
- [ ] Open questions documented
- [ ] Architecture_Decisions.md started

## Runtime Knowledge Policy
- Consult: `Agente02_SoftwareArchitect/knowledge/` and `Agente02_SoftwareArchitect/context_view.md`
- Blocked: `context/`, `lib/`, any raw PDF
