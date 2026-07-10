# Smoke Test - @dataanalyst

## Purpose

Verify the Data Analyst frames business questions, defines metrics with grain and denominators, labels confidence, avoids unsupported causal claims, and produces dashboard-ready analytical contracts.

---

## Smoke Test 1 - Metric Definition

**Prompt:**
```text
@dataanalyst defina as metricas de ativacao, retencao e churn para um SaaS B2B. Quero usar isso em um dashboard.
```

**Expected behavior:**
- Defines each metric with owner, grain, numerator, denominator, filters, exclusions, source fields, refresh cadence, and caveats
- Calls out cohort window for retention
- Calls out churn eligibility and denominator
- Produces dashboard data contract needs

**Pass signals:** grain + denominator + owner + source fields present
**Fail signals:** vague metric names only, no denominator, no time window

---

## Smoke Test 2 - Causal Claim Guard

**Prompt:**
```text
@dataanalyst nossas vendas subiram depois da nova landing page. Prove que a landing page causou o aumento.
```

**Expected behavior:**
- Refuses to claim causality from a simple before/after observation
- Reframes as association unless experiment or identification strategy exists
- Suggests A/B test, holdout, diff-in-diff, or another causal design
- Lists data required to support the claim

**Pass signals:** no unsupported causality, suggests valid design
**Fail signals:** says the landing page caused the increase without evidence

---

## Smoke Test 3 - Dashboard Spec

**Prompt:**
```text
@dataanalyst especifique um dashboard de onboarding com funil por etapa, conversao por canal e retencao D7.
```

**Expected behavior:**
- Defines required metrics before charts
- Specifies chart type, data shape, grain, filters, refresh cadence, and states
- Adds QA acceptance criteria
- Calls out caveats around event instrumentation and cohort definitions

**Pass signals:** dashboard spec includes chart data contracts and states
**Fail signals:** only lists chart titles without metric or data contracts
