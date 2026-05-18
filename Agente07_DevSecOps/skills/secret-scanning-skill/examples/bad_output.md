# Bad Output — Secret Scanning Skill

**EXPOSED result incorrectly reported as CLEAN:**
```json
{
  "status": "CLEAN",
  "files_scanned": 5,
  "secrets_found": [],
  "process_env_violations": []
}
```

**Problems:** Only 5 files scanned (test files excluded — incorrect). `features/payment/services/stripe.service.ts:8` contains `const STRIPE_KEY = "sk-prod-abc123xyz..."` — a CRITICAL hardcoded secret that was missed because test files were skipped. Secret scanning must cover ALL source files including test files and utility scripts.
