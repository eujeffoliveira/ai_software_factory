# Bad Output Example — external-integration-client-skill

```typescript
// lib/integrations/email.client.ts — 3 violations
export async function sendEmail(to: string, subject: string) {
  const response = await fetch("https://api.emailservice.com/v1/send", {
    method: "POST",
    headers: {
      Authorization: `Bearer sk-hardcoded-key-12345`,  // VIOLATION 1: hardcoded secret
      // VIOLATION 2: no timeout — request can hang indefinitely
    },
    body: JSON.stringify({ to, subject }),
  })

  const data = await response.json()  // VIOLATION 3: no Zod validation — runtime type errors
  return data
}

// Elsewhere:
await prisma.$transaction(async (tx) => {
  await tx.email.create({ data: emailRecord })
  await sendEmail(user.email, "Welcome!")  // VIOLATION 4: called inside transaction
})
```

| Violation | Impact | Fix |
|-----------|--------|-----|
| Hardcoded API key | Security leak in git history | Use `env.EMAIL_API_KEY` from `lib/env.ts` |
| No timeout | Hangs transaction/server | Add `signal: AbortSignal.timeout(10_000)` |
| No response validation | Runtime errors on API changes | Add Zod schema, call `.parse()` |
| Called inside `$transaction` | Blocks DB connection, hangs on API failure | Move outside transaction |
