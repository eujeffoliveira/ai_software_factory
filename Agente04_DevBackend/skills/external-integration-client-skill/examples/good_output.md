# Good Output Example — external-integration-client-skill

```typescript
// lib/integrations/email.client.ts
import { z } from "zod"
import { env } from "@/lib/env"  // credentials from lib/env.ts — never process.env

const SendEmailResponseSchema = z.object({
  messageId: z.string(),
  status: z.enum(["queued", "sent"]),
})

export class EmailApiError extends Error {
  constructor(message: string, public readonly statusCode: number) {
    super(message)
    this.name = "EmailApiError"
  }
}

const TIMEOUT_MS = 10_000  // named constant

export const emailClient = {
  async sendEmail(to: string, subject: string, body: string) {
    const response = await fetch(`${env.EMAIL_API_URL}/v1/send`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${env.EMAIL_API_KEY}`,  // from lib/env.ts
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ to, subject, body }),
      signal: AbortSignal.timeout(TIMEOUT_MS),  // always configured
    })

    if (!response.ok) throw new EmailApiError("Email send failed", response.status)

    const data = await response.json()
    return SendEmailResponseSchema.parse(data)  // always validate response
  },
}
```

**Why correct:** env.ts for credentials, Zod response validation, timeout configured, typed error, named const export.
