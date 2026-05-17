// TEMPLATE: Replace all [PLACEHOLDER] values with your implementation.
// File location: lib/integrations/[service].client.ts
//
// RULES for external integration clients:
// 1. Credentials ALWAYS from lib/env.ts — never hardcoded, never process.env directly
// 2. All responses validated with Zod BEFORE use
// 3. Timeout ALWAYS configured (AbortSignal.timeout)
// 4. NEVER called inside prisma.$transaction — external I/O outside transactions
// 5. Error types defined — callers can handle specific failures

import { z } from "zod"
import { env } from "@/lib/env"

// ── Response Schemas ───────────────────────────────────────────────────────────
// Always validate external API responses with Zod before using them.
// This catches API shape changes at runtime instead of causing silent data corruption.

const [Service]ResourceSchema = z.object({
  id: z.string(),
  // name: z.string(),
  // status: z.string(),
  // createdAt: z.string().datetime(),
})

const [Service]ListResponseSchema = z.object({
  data: z.array([Service]ResourceSchema),
  // total: z.number().int(),
  // page: z.number().int(),
})

export type [Service]Resource = z.infer<typeof [Service]ResourceSchema>

// ── Error Types ────────────────────────────────────────────────────────────────
// Define typed errors so callers can handle specific failures.

export class [Service]ApiError extends Error {
  constructor(
    message: string,
    public readonly statusCode: number,
    public readonly responseBody?: unknown
  ) {
    super(message)
    this.name = "[Service]ApiError"
  }
}

export class [Service]RateLimitError extends [Service]ApiError {
  constructor() {
    super("[ServiceName] rate limit exceeded", 429)
    this.name = "[Service]RateLimitError"
  }
}

// ── Client Implementation ──────────────────────────────────────────────────────
// Exported as named const object — consistent with DAL pattern.
// NEVER called inside prisma.$transaction — transactions must not contain I/O.

const BASE_URL = env.[SERVICE]_API_URL  // from lib/env.ts — never process.env directly
const TIMEOUT_MS = 10_000               // 10 second timeout on all requests

export const [service]Client = {
  async get[Resource](id: string): Promise<[Service]Resource> {
    const response = await fetch(`${BASE_URL}/[resource]/${id}`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${env.[SERVICE]_API_KEY}`,  // from lib/env.ts
        "Content-Type": "application/json",
      },
      signal: AbortSignal.timeout(TIMEOUT_MS),
    })

    if (!response.ok) {
      if (response.status === 429) throw new [Service]RateLimitError()
      throw new [Service]ApiError(
        `[ServiceName] API error: ${response.statusText}`,
        response.status
      )
    }

    const data = await response.json()
    // ALWAYS validate external responses with Zod before returning
    return [Service]ResourceSchema.parse(data)
  },

  async list[Resources](params?: { page?: number }): Promise<[Service]Resource[]> {
    const searchParams = new URLSearchParams()
    if (params?.page) searchParams.set("page", String(params.page))

    const response = await fetch(`${BASE_URL}/[resource]?${searchParams}`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${env.[SERVICE]_API_KEY}`,
        "Content-Type": "application/json",
      },
      signal: AbortSignal.timeout(TIMEOUT_MS),
    })

    if (!response.ok) {
      if (response.status === 429) throw new [Service]RateLimitError()
      throw new [Service]ApiError(
        `[ServiceName] API list error: ${response.statusText}`,
        response.status
      )
    }

    const data = await response.json()
    const parsed = [Service]ListResponseSchema.parse(data)
    return parsed.data
  },
}
