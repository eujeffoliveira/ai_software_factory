# Quality Gate — Tech Lead

## Absolute Rule

**The Tech Lead must not approve advancement when the mandatory artifact for the phase is absent.**

No exception. No workaround. No partial approval with intent to fix later.

---

## Gate 1 — PRD Approval

**Trigger:** Product Owner submits `PRD.md` + Handoff Package.

**Mandatory artifacts:**
- `PRD.md`
- Handoff Package

**Validation criteria:**
- [ ] User stories follow INVEST format
- [ ] Each user story has BDD/Gherkin acceptance criteria (Given/When/Then)
- [ ] Functional requirements are documented
- [ ] Non-functional requirements are documented
- [ ] Out-of-scope is explicitly defined
- [ ] Open questions are registered
- [ ] No technology choices embedded in the PRD (no databases, frameworks, or libraries)
- [ ] Handoff Package is complete

**Status codes:**
| Code | Meaning |
|---|---|
| `APPROVED` | PRD is complete and well-formed. Proceed to Architecture. |
| `NEEDS_MORE_REQUIREMENTS` | Acceptance criteria are missing, vague, or untestable. Return to Product Owner. |
| `REJECTED_OUT_OF_SCOPE` | Feature conflicts with defined project scope. Escalate to human. |

---

## Gate 2 — Architecture Approval

**Trigger:** Software Architect submits `Architecture.md` + `API_Contract.json` + DB Schema + Handoff Package.

**Mandatory artifacts:**
- `Architecture.md`
- `API_Contract.json`
- `DB_Schema.sql` or `Prisma_Schema_Proposal.prisma`
- Handoff Package

**Validation criteria:**
- [ ] Architecture follows Golden Model (Next.js 16, App Router, proxy.ts, etc.)
- [ ] Any Golden Path deviation has a corresponding ADR
- [ ] Security strategy is defined (auth, authorization, LGPD)
- [ ] Observability strategy is defined (logs, audit_log, sync_log)
- [ ] Testing strategy is defined (Vitest, Playwright)
- [ ] Deployment strategy is defined (Vercel, CI/CD, migrations)
- [ ] API contract is complete (endpoints, methods, request/response schemas, auth)
- [ ] DB schema uses Prisma conventions (camelCase model, snake_case DB mapping)
- [ ] Technical risks are identified
- [ ] Handoff Package is complete

**Status codes:**
| Code | Meaning |
|---|---|
| `APPROVED` | Architecture is complete and Golden Model compliant. Proceed to Task Planning. |
| `APPROVED_WITH_ADR` | Architecture approved but contains Golden Path deviation covered by an ADR. |
| `NEEDS_REVISION` | Specific issues identified. Return to Architect with correction list. |
| `REJECTED_RISK_TOO_HIGH` | Risk level exceeds acceptable threshold. Escalate to human + trigger Council. |

---

## Gate 3 — Execution Plan Approval

**Trigger:** Software Engineer submits `Execution_Plan.json` + Handoff Package.

**Mandatory artifacts:**
- `Execution_Plan.json`
- Handoff Package

**Validation criteria:**
- [ ] All tasks have unique IDs
- [ ] Each task is atomic (fits within LLM context window)
- [ ] Dependencies are mapped correctly
- [ ] Files to create/edit are specified per task
- [ ] Acceptance criteria are associated with each task
- [ ] Security requirements are associated with relevant tasks
- [ ] Test requirements are associated with relevant tasks
- [ ] Execution order is viable and respects dependencies
- [ ] No task is overly large or ambiguous
- [ ] Handoff Package is complete

**Status codes:**
| Code | Meaning |
|---|---|
| `APPROVED` | Execution plan is atomic, ordered, and ready for implementation. |
| `NEEDS_TASK_SPLIT` | One or more tasks are too large or complex. Return for decomposition. |
| `NEEDS_DEPENDENCY_FIX` | Dependency chain has conflicts or cycles. Return for correction. |

---

## Gate 4 — QA Review

**Trigger:** QA Engineer submits `QA_Report.md` + Handoff Package.

**Mandatory artifacts:**
- `QA_Report.md`
- Handoff Package

**Validation criteria:**
- [ ] All acceptance criteria from PRD were evaluated
- [ ] Typecheck result is reported
- [ ] Lint result is reported
- [ ] Test execution results are reported
- [ ] Each failure is classified with severity
- [ ] Status is explicitly stated (PASS / FAIL_FIX_REQUIRED / FAIL_BLOCKING)

**Status codes:**
| Code | Meaning |
|---|---|
| `PASS` | All acceptance criteria met. Proceed to Security Review. |
| `FAIL_FIX_REQUIRED` | Non-critical failures found. Return to Dev with specific issues. |
| `FAIL_BLOCKING` | Critical failures found. Block pipeline. Return to Dev immediately. |

---

## Gate 5 — Security Review

**Trigger:** DevSecOps submits `Security_Audit.md` + Handoff Package.

**Mandatory artifacts:**
- `Security_Audit.md`
- Handoff Package

**Validation criteria:**
- [ ] OWASP Top 10 review was performed
- [ ] Data protection compliance (LGPD/GDPR) assessment was performed
- [ ] Secrets and credentials were verified (no hardcoding)
- [ ] Authorization was verified (server-side checks present)
- [ ] Sensitive data in logs was verified (no PII in plain text)
- [ ] Critical dependencies were scanned when applicable
- [ ] Status is explicitly stated

**Status codes:**
| Code | Meaning |
|---|---|
| `APPROVED` | No security issues found. Proceed to Deployment. |
| `APPROVED_WITH_WARNINGS` | Minor non-blocking issues. Document and proceed with mitigation plan. |
| `BLOCKED_SECURITY_RISK` | Critical security vulnerability found. Block pipeline. Escalate to human. |
| `BLOCKED_PRIVACY_RISK` | Critical data protection compliance risk found. Block pipeline. Escalate to human. |

---

## Gate 6 — Deployment Approval

**Trigger:** DevOps submits `Deployment_Plan.md` + `Rollback_Plan.md` + Handoff Package.

**Mandatory artifacts:**
- `Deployment_Plan.md`
- `Rollback_Plan.md` (mandatory — no deploy without rollback plan)
- `Environment_Checklist.md`
- Handoff Package

**Validation criteria:**
- [ ] Rollback plan is present and complete (conditions, steps, responsible, validation)
- [ ] Environment variables are validated for target environment
- [ ] Migration plan is defined (type: reversible/compatible/irreversible/destructive)
- [ ] Healthcheck endpoint (`/api/health`) is defined
- [ ] Smoke tests post-deploy are defined
- [ ] Human approval has been obtained for production deployments
- [ ] Secrets are not reused between environments

**Status codes:**
| Code | Meaning |
|---|---|
| `READY_FOR_DEPLOY` | All checks passed. Human approved. Proceed with deployment. |
| `NEEDS_ENV_FIX` | Environment variables missing or incorrect. Return to DevOps. |
| `NEEDS_ROLLBACK_PLAN` | Rollback plan missing or incomplete. Block. Return to DevOps. |
| `BLOCKED_PRODUCTION_APPROVAL_REQUIRED` | Deployment requires human approval not yet received. Escalate and wait. |

---

## Gate 7 — Post-Deploy Validation

**Trigger:** DevOps submits `Post_Deploy_Report.md`.

**Mandatory artifacts:**
- `Post_Deploy_Report.md`

**Validation criteria:**
- [ ] `/api/health` returned healthy
- [ ] Critical user flows verified (login, main screen)
- [ ] Logs checked for errors in first 15 minutes
- [ ] APM metrics checked when available
- [ ] Migration executed without errors (when applicable)

**Status codes:**
| Code | Meaning |
|---|---|
| `DEPLOY_HEALTHY` | All validations passed. Deployment successful. Close cycle. Update State Ledger. |
| `DEPLOY_DEGRADED` | Partial degradation detected. Monitor and define action plan. Notify human. |
| `ROLLBACK_REQUIRED` | Critical failure detected. Trigger rollback immediately. Escalate to human. |
| `INCIDENT_OPENED` | Incident opened. Activate incident response. Human is primary decision-maker. |

---

## Cross-Gate Rules

1. **Gate skipping is forbidden.** Every phase must produce its gate decision before the next phase begins.
2. **Missing artifact = blocked gate.** No exceptions.
3. **BLOCKED status always requires human notification.**
4. **State Ledger must be updated after every gate decision.**
5. **When in doubt, escalate to human rather than making an irreversible decision.**
