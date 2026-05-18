# Agente07_DevSecOps — Skills Manifest

> Index of all authorized skills. At runtime, only these skills may be invoked. Each skill is self-contained with its own input/output schema, checklist, and examples.

---

## Skill Index

| # | Skill ID | Folder | Trigger Condition |
|---|----------|--------|-------------------|
| 1 | threat-modeling-skill | `skills/threat-modeling-skill/` | Feature involves auth, authz, or sensitive data; Threat_Model.md missing or incomplete |
| 2 | owasp-review-skill | `skills/owasp-review-skill/` | Every Gate 5 evaluation — mandatory for all 10 OWASP categories |
| 3 | privacy-review-skill | `skills/privacy-review-skill/` | Feature handles CONFIDENTIAL or RESTRICTED data; LGPD/GDPR obligations identified |
| 4 | secret-scanning-skill | `skills/secret-scanning-skill/` | Every Gate 5 evaluation — mandatory scan of all reviewed source files |
| 5 | authz-review-skill | `skills/authz-review-skill/` | Every Gate 5 evaluation — mandatory auth/authz pattern check |
| 6 | security-audit-report-skill | `skills/security-audit-report-skill/` | Every Gate 5 evaluation — always the final skill, produces Security_Audit.md |
| 7 | dependency-security-review-skill | `skills/dependency-security-review-skill/` | Every Gate 5 evaluation — mandatory review of package.json dependencies |
| 8 | secure-code-remediation-skill | `skills/secure-code-remediation-skill/` | Any BLOCKED or RETURNED decision — produces Remediation_Guide.md |
| 9 | logging-privacy-review-skill | `skills/logging-privacy-review-skill/` | Every Gate 5 evaluation — mandatory audit of audit_log and sync_log calls |
| 10 | data-classification-skill | `skills/data-classification-skill/` | Step 2 of every Gate 5 evaluation — classifies all data entities before other reviews |

---

## Skill Execution Order

The following order is mandatory. Some skills can run in parallel after data classification:

```
Step 1: [Entry validation — not a skill, inline check]
    Confirm QA_Report.md with gate_ready: true exists.

Step 2: data-classification-skill
    Classify all data entities. Results drive subsequent skill scope.

Step 3: threat-modeling-skill (if feature has auth/authz/sensitive data)
    Verify or produce Threat_Model.md. Must complete before owasp-review-skill.

Step 4: [PARALLEL] — all of the following run simultaneously:
    - secret-scanning-skill
    - authz-review-skill
    - dependency-security-review-skill
    - logging-privacy-review-skill
    - owasp-review-skill

Step 5: privacy-review-skill
    Uses results from data-classification-skill and logging-privacy-review-skill.

Step 6: security-audit-report-skill
    Aggregates all findings into Security_Audit.md and issues Gate 5 decision.

Step 7: secure-code-remediation-skill (only if BLOCKED or RETURNED)
    Produces Remediation_Guide.md from all findings.
```

---

## Skill Descriptions

### 1. threat-modeling-skill
**Purpose:** Create or validate STRIDE threat models for features involving authentication, authorization, or sensitive data.
**When to trigger:** (a) Feature involves `auth()` calls, role-based access, or user session handling. (b) Feature stores or processes CONFIDENTIAL or RESTRICTED data. (c) Threat_Model.md is missing. (d) Existing Threat_Model.md does not cover all six STRIDE categories.
**Outputs:** `Threat_Model.md` — complete STRIDE analysis with trust boundaries, assets, threats, likelihoods, impacts, and mitigations.
**Gate behavior:** If this skill cannot produce a valid threat model (insufficient information), issue `BLOCKED_PENDING_HUMAN` and escalate.

### 2. owasp-review-skill
**Purpose:** Systematically evaluate the implementation against all 10 OWASP Top 10 (2021) categories.
**When to trigger:** Every Gate 5 evaluation — all 10 categories are mandatory.
**Outputs:** OWASP coverage table (10 rows) with PASS/FAIL for each category and specific findings per failure.
**Gate behavior:** Any FAIL in A01, A02, A03, or A07 is typically CRITICAL. Other categories vary by finding severity.

### 3. privacy-review-skill
**Purpose:** Assess privacy compliance for features handling CONFIDENTIAL or RESTRICTED data.
**When to trigger:** (a) data-classification-skill identifies CONFIDENTIAL or RESTRICTED entities. (b) Feature collects, stores, or processes user PII (email, name, health, financial). (c) Third-party data sharing is involved.
**Outputs:** `Privacy_Assessment.md` — LGPD/GDPR compliance status, findings, and escalation requirements.
**Gate behavior:** Unresolved CONFIDENTIAL data without consent = `BLOCKED_PRIVACY_VIOLATION`. RESTRICTED data without human sign-off = `BLOCKED_PENDING_HUMAN`.

### 4. secret-scanning-skill
**Purpose:** Scan all source files for hardcoded secrets, exposed credentials, and misplaced environment variable access.
**When to trigger:** Every Gate 5 evaluation — mandatory.
**Outputs:** Secrets scan report (clean or list of findings with exact file:line references).
**Gate behavior:** Any hardcoded secret = CRITICAL finding, `BLOCKED_SECRET_EXPOSED`, immediate escalation.

### 5. authz-review-skill
**Purpose:** Validate authentication and authorization patterns in all Server Actions, Route Handlers, and Cron routes.
**When to trigger:** Every Gate 5 evaluation — mandatory.
**Outputs:** Auth/authz review report — per-route checklist results with PASS/FAIL.
**Gate behavior:** Missing `auth()` check = `BLOCKED_AUTH_BYPASS`. IDOR = `BLOCKED_AUTH_BYPASS`. userId from request body = CRITICAL.

### 6. security-audit-report-skill
**Purpose:** Aggregate all findings from parallel skills and produce `Security_Audit.md` with the Gate 5 decision.
**When to trigger:** Always — final skill in every Gate 5 evaluation.
**Outputs:** `Security_Audit.md` — the primary Gate 5 decision artifact with all mandatory sections.
**Gate behavior:** This skill issues the final gate status code based on finding aggregation.

### 7. dependency-security-review-skill
**Purpose:** Analyze `package.json` and `package-lock.json` for known CVEs and apply CVSS-based severity thresholds.
**When to trigger:** Every Gate 5 evaluation — mandatory.
**Outputs:** Dependency vulnerability report — list of packages reviewed, CVEs found, CVSS scores, and severity classification.
**Gate behavior:** CVSS ≥ 9.0 = CRITICAL block. CVSS 7.0–8.9 = HIGH (must remediate before APPROVED).

### 8. secure-code-remediation-skill
**Purpose:** Produce `Remediation_Guide.md` with specific, actionable fix guidance for every non-LOW finding.
**When to trigger:** Any BLOCKED or RETURNED gate decision — mandatory companion output.
**Outputs:** `Remediation_Guide.md` — per-finding remediation with exact file path, code pattern to remove, and correct replacement pattern.
**Note:** This skill guides remediation but does not write the actual code fixes. Dev agents implement the fixes.

### 9. logging-privacy-review-skill
**Purpose:** Audit all `audit_log` and `sync_log` calls for PII exposure, log injection, and token leakage.
**When to trigger:** Every Gate 5 evaluation — mandatory.
**Outputs:** Logging privacy report — per-log-call audit with PASS/FAIL and finding descriptions.
**Gate behavior:** Raw PII in log fields = HIGH, `BLOCKED_PRIVACY_VIOLATION`. Password or token logged = CRITICAL.

### 10. data-classification-skill
**Purpose:** Classify all data entities handled by the feature into PUBLIC, INTERNAL, CONFIDENTIAL, or RESTRICTED tiers.
**When to trigger:** Step 2 of every Gate 5 evaluation — must complete before privacy-review-skill.
**Outputs:** `Data_Classification.md` — entity-by-entity classification table with tier rationale.
**Gate behavior:** RESTRICTED data identified = trigger `BLOCKED_PENDING_HUMAN` if no human sign-off documented.

---

## Executable Tools

The following runtime tools are in `Agente07_DevSecOps/tools/`.

### Git Security Hooks (`tools/git-hooks/`)

Claude Code lifecycle hooks that enforce security policies. Install via `.claude/settings.json`.

| Script | Hook Type | Blocks |
|--------|-----------|--------|
| `bash-guards.sh` | PreToolUse(Bash) | Force push, --no-verify, rebase -i, git reset --hard |
| `config-guard.sh` | PreToolUse(Write) | Writes to .env, package.json, tsconfig, CI workflows |
| `secret-scan.sh` | PostToolUse(Edit/Write) | Advisory — warns on API keys, passwords, DB strings |
| `security-gate.sh` | PreToolUse | Entry point delegating to bash-guards.sh |

See `tools/git-hooks/README.md` for installation instructions.

### SENTINEL Security Framework (`tools/sentinel/`)

| File | Purpose |
|------|---------|
| `sentinel-certificate.md` | Fill and issue when SSS >= 80 to unblock Gate 5 |
| `sentinel-state.json` | Current security posture (update after each security review) |
| `k6-template.js` | Load testing: 5 profiles (smoke/load/stress/spike/endurance); p95 < 2s |

**Deployment gate:** SSS score >= 80 required before Gate 5 approval.

```bash
# Run smoke load test
k6 run --env PROFILE=smoke Agente07_DevSecOps/tools/sentinel/k6-template.js
```
