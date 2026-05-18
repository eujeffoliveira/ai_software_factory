# Secret Scanning Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/checklists/secrets_checklist.md` and `Agente07_DevSecOps/knowledge/decision_rules.md` (DR001, DR008) before executing. Do NOT access `context/` or `lib/`.

## Scan Coverage
- [ ] All TypeScript/JavaScript source files scanned (including test files)
- [ ] JSON config files scanned
- [ ] Shell scripts scanned
- [ ] Code comments scanned
- [ ] .env files checked against .gitignore

## Pattern Checks
- [ ] API key literals (sk-, xai-, AKIA, ya29., ghp_, glpat-, AIza)
- [ ] Connection strings (postgres://, mysql://, mongodb+srv://, redis://)
- [ ] Auth secrets (NEXTAUTH_SECRET, JWT_SECRET, client_secret, Bearer tokens)
- [ ] Generic credentials (password=, passwd=, api_key=, apiKey=, secret=)
- [ ] process.env.* outside lib/env.ts
- [ ] .env files in version control

## For Each Match
- [ ] Verify it is a real secret (not placeholder like "<YOUR_KEY>")
- [ ] Record exact file:line
- [ ] Assign SEC-NNN finding ID
- [ ] Mark DR001 as the decision rule
- [ ] Flag for secret rotation (escalate to Tech Lead)

## Output
- [ ] status: CLEAN if no hardcoded secrets found
- [ ] status: EXPOSED if any hardcoded secret found (triggers BLOCKED_SECRET_EXPOSED)
- [ ] All process_env_violations listed with severity
