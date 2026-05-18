# Dependency Security Checklist

> Run this checklist on every Gate 5 evaluation. CVSS ≥ 9.0 = CRITICAL block. CVSS 7.0–8.9 = HIGH (must remediate).

## Runtime Knowledge Policy

Read from `Agente07_DevSecOps/knowledge/decision_rules.md` (DR006, DR007) and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 006 — CVSS) before executing. Do NOT access `context/` or `lib/` at runtime.

---

## Step 1: Identify Dependencies

- [ ] Read `package.json` — list all production dependencies (`dependencies`)
- [ ] Read `package.json` — list all development dependencies (`devDependencies`)
- [ ] Note: focus security review on production dependencies; devDependencies are lower priority but still reviewed
- [ ] Note `package-lock.json` is present and committed (absence is a finding)

**Total production dependencies:** [N]
**Total dev dependencies:** [N]

---

## Step 2: npm Audit

- [ ] Run `npm audit` (or review provided `npm audit` output)
- [ ] Read the complete audit report — do not skip warnings
- [ ] Extract: total vulnerabilities by severity, specific packages, CVE IDs, CVSS scores

**npm audit summary:**
| Severity | Count |
|---------|-------|
| Critical | [N] |
| High | [N] |
| Moderate | [N] |
| Low | [N] |
| Info | [N] |

---

## Step 3: CVSS Classification

For each vulnerability found, classify per decision rules:

| Package | Version | CVE | CVSS | Severity | Action Required |
|---------|---------|-----|------|----------|----------------|
| [pkg] | [ver] | [CVE-XXXX-XXXXX] | [score] | CRITICAL/HIGH/MEDIUM/LOW | Upgrade/Remove/Accept |

**CVSS ≥ 9.0 (CRITICAL):**
- [ ] Count: [N]
- [ ] Action: issue `BLOCKED_CRITICAL_RISK`, escalate, require upgrade before APPROVED

**CVSS 7.0–8.9 (HIGH):**
- [ ] Count: [N]
- [ ] Action: require remediation before APPROVED; or human risk acceptance

**CVSS 4.0–6.9 (MEDIUM):**
- [ ] Count: [N]
- [ ] Action: track in backlog; may proceed to APPROVED

**CVSS 0.1–3.9 (LOW):**
- [ ] Count: [N]
- [ ] Action: informational; note in audit

---

## Step 4: Outdated Package Check

For packages where CVSS data is not available or the package is not in the npm audit database:

- [ ] Check major version — is the package significantly behind the current stable release?
- [ ] Check repository — is the package archived, deprecated, or unmaintained?
- [ ] Flag packages that are > 2 major versions behind as MEDIUM (potential untracked CVEs)

| Package | Current Version | Latest Version | Status |
|---------|----------------|---------------|--------|
| [pkg] | [ver] | [latest] | UP_TO_DATE / OUTDATED |

---

## Step 5: High-Risk Package Categories

Extra scrutiny on these package categories (historically higher CVE frequency):

- [ ] **Serialization/parsing**: `xml2js`, `yaml`, `ini`, `marked`, any XML or YAML parser
- [ ] **Image processing**: `sharp`, `imagemagick` wrappers
- [ ] **ZIP/archive**: any decompression library
- [ ] **PDF generation**: `pdfkit`, `puppeteer`, any PDF library
- [ ] **Template engines**: `handlebars`, `pug`, `ejs`
- [ ] **Auth libraries**: any library not NextAuth v5 in the Golden Path
- [ ] **HTTP clients**: `axios`, `node-fetch`, `got`

For any package in these categories, verify it is at its latest stable version.

---

## Step 6: Lock File Integrity

- [ ] `package-lock.json` is present in the repository
- [ ] `package-lock.json` is committed (not in `.gitignore`)
- [ ] `package-lock.json` is consistent with `package.json` (no uncommitted changes)

**Status:** ✅ PASS / ❌ FAIL

---

## Dependency Security Summary

| Check | Result |
|-------|--------|
| npm audit run | YES / NO |
| CVSS ≥ 9.0 findings | [N found] |
| CVSS 7.0–8.9 findings | [N found] |
| CVSS 4.0–6.9 findings | [N found] |
| Unmaintained packages | [N found] |
| Lock file present | YES / NO |

**Overall dependency security status:** CLEAN / CRITICAL_CVE_FOUND / HIGH_CVE_FOUND / MEDIUM_CVE_FOUND

**Gate 5 impact:**
- Any CVSS ≥ 9.0 → `BLOCKED_CRITICAL_RISK`
- Any CVSS 7.0–8.9 → Gate blocked until resolved or human risk acceptance
- CVSS 4.0–6.9 → MEDIUM finding, may proceed
