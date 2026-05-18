# Secure Code Remediation Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/knowledge/decision_rules.md` (DR014, DR015) and `Agente07_DevSecOps/context_view.md` (Section 4 — Golden Path patterns) before executing. Do NOT access `context/` or `lib/`.

## Pre-execution
- [ ] Gate decision is BLOCKED or RETURNED (this skill is not run for APPROVED)
- [ ] All findings from security-audit-report-skill are available
- [ ] File paths and code snippets are available for each finding

## Per Finding (CRITICAL and HIGH — mandatory; MEDIUM — recommended)
- [ ] finding_id assigned
- [ ] Exact file path and line number documented
- [ ] wrong_pattern: the actual vulnerable code from the file (quoted exactly)
- [ ] correct_pattern: the Golden Path compliant replacement (specific, not generic)
- [ ] Additional steps listed if applicable (rotate secret, update schema, etc.)
- [ ] responsible_agent identified
- [ ] decision_rule referenced

## Systemic Check (DR015)
- [ ] Count how many times each vulnerability class appears
- [ ] If 3+ occurrences of same class: add systemic_recommendations section
- [ ] Systemic recommendation includes: search pattern for codebase-wide check

## Resubmission Requirements
- [ ] All CRITICAL must be fixed listed
- [ ] All HIGH must be fixed (or human risk acceptance) listed
- [ ] Required resubmission artifacts listed

## Output
- [ ] Remediation_Guide.md produced following template
- [ ] remediation_guide_produced: true
- [ ] findings_remediated: count of items with guidance
