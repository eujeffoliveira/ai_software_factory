# Agente08_DevOps — Operational Principles

Principles P1–P12, distilled from the DevOps bibliography at build time. At runtime, consult this file — do not access `lib/` or source books directly.

---

## P1 — Deployment Pipeline Is the Production Quality Gate

**Source:** Continuous Delivery – Humble & Farley (Ch. 5: Anatomy of the Deployment Pipeline)

A deployment pipeline is the only mechanism by which changes should flow from developer workstation to production. Every stage of the pipeline — commit stage (compile, unit test, analysis), acceptance stage (automated acceptance tests), and production deployment — is a gate. A change that has not passed all pipeline stages is not deployable. DevOps owns the final stages of this pipeline.

**Operational implication:** Never deploy a commit that has not passed all prior pipeline stages (Gates 1–5). Gate 6 preparation begins only after Gate 5 `APPROVED`.

---

## P2 — Trunk-Based Development Enables Continuous Delivery

**Source:** Continuous Delivery – Humble & Farley (Ch. 14: Advanced Version Control)

Short-lived feature branches merged to main/trunk frequently (at least daily) reduce integration risk and enable a stable, always-deployable main branch. Long-lived branches accumulate merge debt and deployment risk. The deployment pipeline runs on every commit to main.

**Operational implication:** Expect deployments from the main branch. Large-batch releases (many changes accumulated) carry higher change failure rate. Flag this pattern to Tech Lead when observed.

---

## P3 — Infrastructure Should Be Reproducible and Idempotent

**Source:** Infrastructure as Code – Kief Morris (Ch. 2: Principles of Infrastructure as Code)

Infrastructure configuration (environment variables, Vercel project settings, database schema) must be defined in code or configuration files, stored in version control, and applied consistently across environments. Running the same configuration twice must produce the same result (idempotency). Manual changes to production configuration outside of the defined process create untracked drift.

**Operational implication:** Vercel environment variables must be managed through a documented process. Prisma migrations are the canonical definition of database schema state — `prisma migrate deploy` is idempotent (only applies pending migrations). Any manual DB change outside migrations is an infrastructure drift violation.

---

## P4 — Observe Before Optimizing — SLOs Define Acceptable Behavior

**Source:** Site Reliability Engineering – Murphy et al. (Ch. 4: Service Level Objectives)

Service Level Objectives (SLOs) define the target reliability for a service. SLOs are derived from SLIs (Service Level Indicators — measurable metrics like error rate, latency, availability). Without defined SLOs, there is no objective basis for declaring a deployment "healthy" or "failing." DORA metrics (Deployment Frequency, Lead Time, Change Failure Rate, MTTR) are the SLIs for the deployment process itself.

**Operational implication:** Gate 7 uses concrete SLO thresholds: healthcheck 200 for 5 minutes, error rate < 5% for 10 minutes, smoke tests all passing. These are not arbitrary — they define the minimum acceptable service level post-deploy.

---

## P5 — Toil Reduction Frees Capacity for Reliability Improvement

**Source:** Site Reliability Engineering – Murphy et al. (Ch. 5: Eliminating Toil)

Toil is operational work that is manual, repetitive, automatable, tactical, and devoid of enduring value. High toil levels crowd out reliability engineering work. Every deployment task that must be done manually every cycle is a toil candidate. Toil should be identified, measured, and systematically automated.

**Operational implication:** Manual deployment steps, manual healthcheck monitoring, manual log review — all are toil candidates. Invest in CI/CD automation to reduce the manual surface of each deployment. Document toil identified in Post_Deploy_Report.md improvement section.

---

## P6 — The Three Ways: Flow, Feedback, Continual Learning

**Source:** The Phoenix Project – Gene Kim et al. (Part III: The Three Ways)

**First Way (Flow):** Optimize the flow of work from left to right (development to production). Remove bottlenecks, reduce batch sizes, prevent defects from being passed downstream.

**Second Way (Feedback):** Amplify feedback loops from right to left (production to development). Fast detection and recovery from failures. Structured telemetry enables feedback.

**Third Way (Continual Learning):** Create a culture of experimentation and learning from failures. Blameless postmortems. Non-punitive incident reporting.

**Operational implication:** DevOps is the "right side" of the flow. Structured logs (`audit_log`, `sync_log`), healthcheck monitoring, and Post_Deploy_Report.md are feedback mechanisms. Postmortems when MTTR > 1 hour are continual learning.

---

## P7 — Error Budget Balances Reliability and Innovation

**Source:** Site Reliability Engineering – Murphy et al. (Ch. 3: Embracing Risk)

If a service has a 99.9% availability SLO, it has a 0.1% error budget — the amount of unreliability allowed. When the error budget is consumed (too many incidents, too many failed deployments), the focus shifts from feature development to reliability work. When the budget is healthy, innovation can proceed at higher velocity.

**Operational implication:** Change Failure Rate < 15% is the DevOps error budget at the pipeline level. When Change Failure Rate exceeds 15% for two consecutive deployment cycles, reliability work (runbook improvement, test coverage, staging-production parity) takes priority over new feature deployment.

---

## P8 — Rollback Is a First-Class Operation

**Source:** Continuous Delivery – Humble & Farley (Ch. 10: Deploying and Releasing Applications)

Rollback is not an emergency improvisation — it is a planned, tested operation. A deployment plan without a tested rollback procedure is incomplete. The cost of rollback must be known in advance. For Vercel deployments, rollback is fast (~5 minutes). For database changes, rollback requires a forward-fix migration (not backward).

**Operational implication:** `Rollback_Plan.md` is a Gate 6 prerequisite, not an optional document. The rollback procedure must be verified in staging before production deployment. Gate 6 is blocked without a complete rollback plan.

---

## P9 — Environment Parity Prevents "Works on My Machine"

**Source:** Continuous Delivery – Humble & Farley (Ch. 11: Managing Infrastructure and Environments)

The greater the difference between environments (local, staging, production), the higher the risk of environment-specific failures. Secrets, configuration, database content, and infrastructure configuration should mirror each other across environments as closely as possible — with the exception that secrets must be distinct per environment.

**Operational implication:** Staging must mirror production configuration. Both use the same `lib/env.ts` Zod schema, same Prisma schema, same Vercel platform. The `environment-validation-skill` enforces parity by comparing env var sets across environments. Smoke tests in staging catch environment-specific issues before production exposure.

---

## P10 — DORA Metrics Are the Compass for DevOps Improvement

**Source:** The DevOps Handbook – Gene Kim et al. (Part I: The Three Ways)

The four DORA (DevOps Research and Assessment) metrics measure the performance of a delivery pipeline:
1. **Deployment Frequency** — how often code deploys to production
2. **Lead Time for Changes** — time from commit to production
3. **Change Failure Rate** — % of deployments that cause incidents
4. **Mean Time to Recovery (MTTR)** — time to restore service after incident

Elite performers: deploy on-demand, lead time < 1 day, change failure rate < 15%, MTTR < 1 hour.

**Operational implication:** Golden Path targets: Deployment Frequency weekly, Lead Time < 1 day, Change Failure Rate < 15%, MTTR < 1 hour. DevOps tracks these in Post_Deploy_Report.md. When any metric degrades, investigate the root cause before the next deployment.

---

## P11 — Configuration Management Ensures Environment Consistency

**Source:** Módulo 11 – Gerência de Configuração (Aula 1: Fundamentos de Gerência de Configuração)

Configuration management (CM) is the discipline of tracking and controlling changes to software and infrastructure configuration items. All configuration items — code, configuration files, environment settings, database schemas — must be versioned, tracked, and auditable. Changes to configuration should be controlled (reviewed, approved) and reproducible.

**Operational implication:** Prisma migration files are configuration items — they must be committed to source control before deployment. Vercel environment variables are configuration items — changes should be documented. CI/CD pipeline configuration is a configuration item — changes require team awareness. Any untracked configuration change is a CM violation.

---

## P12 — Change Control Prevents Untracked Drift

**Source:** Módulo 11 – Gerência de Configuração (Aula 3: Controle de Mudanças)

Change control ensures that every change to a system is: requested (change request), assessed for impact and risk, approved by an appropriate authority, implemented through the defined process, and verified. Uncontrolled changes (hotfixes, manual DB edits, direct production config changes outside the pipeline) create configuration drift — a state where the deployed system does not match the source of truth.

**Operational implication:** All production changes go through the pipeline (Gates 1–7). No hotfixes, no `prisma db push`, no manual DB edits, no manual Vercel config changes outside the documented deployment process. Every change must be traceable to a commit, a migration file, or a documented configuration decision.
