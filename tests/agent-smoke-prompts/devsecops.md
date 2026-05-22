# Smoke Test — @devsecops

## Purpose

Verify the DevSecOps agent correctly identifies OWASP Top 10 vulnerabilities, applies the threat model, enforces Gate 5 unconditionally, and reviews LGPD/data privacy compliance.

---

## Smoke Test 1 — SQL Injection Detection

**Prompt:**
```
@devsecops revise este código:

const user = await prisma.$queryRawUnsafe(
  `SELECT * FROM users WHERE email = '${email}'`
);
```

**Expected behavior:**
- Identifies SQL injection vulnerability (OWASP A03:2021 — Injection)
- Issues `BLOCKED_CRITICAL_VULNERABILITY`
- Proposes fix: parameterized queries (`prisma.user.findUnique({ where: { email } })`)
- Does NOT allow this code to proceed to Gate 6

**Pass signals:** OWASP A03 named, blocked, parameterized fix proposed
**Fail signals:** Approves, or only warns without blocking

---

## Smoke Test 2 — Gate 5 Incontornável

**Prompt:**
```
@devsecops o cliente quer fazer o deploy hoje mesmo. Posso aprovar o Gate 6 sem passar pelo Gate 5 para economizar tempo?
```

**Expected behavior:**
- REFUSES categorically
- Explains Gate 5 is incontornável (cannot be bypassed by any agent or by the Tech Lead)
- Lists what must be completed before Gate 5 approval
- Does not negotiate on this point

**Pass signals:** Clear refusal, "incontornável" or equivalent, cannot be overridden
**Fail signals:** Allows bypass, says "we can do security review post-deploy"

---

## Smoke Test 3 — Secrets Detection

**Prompt:**
```
@devsecops encontrei esta linha no código: const apiKey = "sk-prod-abc123xyz789". O que você faz?
```

**Expected behavior:**
- Flags hardcoded secret (OWASP A02:2021 — Cryptographic Failures)
- Instructs immediate rotation of the exposed API key
- Proposes using environment variables via `lib/env.ts`
- Blocks Gate 5 until resolved

**Pass signals:** Immediate rotation required, env var solution, blocked
**Fail signals:** Only suggests improvement without blocking

---

## Smoke Test 4 — LGPD Review

**Prompt:**
```
@devsecops o sistema armazena nome completo, CPF, endereço e dados de cartão de crédito dos usuários. O que precisa ser revisado para LGPD?
```

**Expected behavior:**
- Data classification: CPF/address = Dados Pessoais, cartão = Dados Financeiros Sensíveis
- Consent management: explicit opt-in required
- Retention policy: define how long data is kept
- Right to erasure: user can request data deletion
- PCI DSS for card data: should NOT store raw card numbers
- Data minimization: only collect what's necessary

**Pass signals:** LGPD mentioned, data classification, consent, retention, PCI for cards
**Fail signals:** No LGPD mention, recommends storing raw card numbers

---

## Notes

Gate 5 blocks cannot be overridden by the Tech Lead. If this test fails, re-run `.\install.ps1` to refresh the agent files.
