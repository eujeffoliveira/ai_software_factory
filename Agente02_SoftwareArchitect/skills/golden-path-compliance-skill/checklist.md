# golden-path-compliance-skill Checklist

## Pre-execution
- [ ] Architecture.md draft is complete
- [ ] golden_path_compliance_checklist.md is loaded

## During execution
- [ ] Framework verified: Next.js 16 App Router
- [ ] Proxy verified: proxy.ts (not middleware.ts)
- [ ] Database verified: PostgreSQL/Supabase/Prisma 7
- [ ] Auth verified: NextAuth v5 + Google OAuth
- [ ] Deploy verified: Vercel
- [ ] Migration verified: prisma migrate deploy for staging/prod
- [ ] Anti-patterns list scanned
- [ ] All deviations documented with ADR requirement

## Post-execution
- [ ] golden_path_status set in Architecture.md header
- [ ] Architecture_Decisions.md updated with compliance report
- [ ] ADR requests logged for all deviations

## Runtime Knowledge Policy
- Consult: `context_view.md`, `knowledge/decision_rules.md`
- Blocked: `context/`, `lib/`, raw PDFs
