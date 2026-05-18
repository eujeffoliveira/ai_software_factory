# Bad Output — environment-validation-skill

**Overall Status:** PASS ❌ WRONG — production is missing SENTRY_DSN

**Staging:** 7/7 present
**Production:** 6/7 present (SENTRY_DSN missing) ← noted but marked PASS anyway
**Isolation:** not checked ❌
**Scattered process.env:** not checked ❌

**WHAT IS WRONG:**
- Missing env var in production = FAIL, not PASS. Deploy will fail at boot.
- Isolation check skipped — shared secrets would go undetected (DR008 violation risk)
- Scattered env scan skipped — DR003 violations not caught
