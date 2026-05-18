# Good Output — Secret Scanning Skill

**CLEAN result (18 files scanned):**
```json
{
  "status": "CLEAN",
  "files_scanned": 18,
  "secrets_found": [],
  "process_env_violations": [
    {
      "finding_id": "SEC-001",
      "location": "scripts/dev-seed.ts:12",
      "variable_name": "DATABASE_URL",
      "severity": "MEDIUM",
      "decision_rule": "DR008"
    }
  ],
  "gitignore_env_excluded": true
}
```

One MEDIUM finding for process.env outside lib/env.ts in a dev script. No hardcoded secrets.
