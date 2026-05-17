// TEMPLATE: Replace all [PLACEHOLDER] values with your implementation.
// File location: app/api/[resource]/route.ts
// Rule: Route handlers are THIN — auth + parse + delegate + respond.
// Target: ≤ 30 lines. If longer, business logic has leaked in — extract to features/.

import { auth } from "@/lib/auth"
import { NextRequest, NextResponse } from "next/server"
import { z } from "zod"
import { [domainService] } from "@/features/[domain]/[domain].service"

// ── Param/Query Schemas ────────────────────────────────────────────────────────
// Define at module level — not inline.
// Use only for validating request parameters (query params, path params, body).
const QuerySchema = z.object({
  // page: z.coerce.number().int().min(1).default(1),
  // pageSize: z.coerce.number().int().min(1).max(100).default(20),
})

// ── GET Handler ────────────────────────────────────────────────────────────────
export async function GET(req: NextRequest): Promise<NextResponse> {
  // Step 1: Auth — ALWAYS FIRST. Return 401 immediately for unauthenticated.
  const session = await auth()
  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  // Step 2: Validate query params
  const { searchParams } = req.nextUrl
  const query = QuerySchema.safeParse(Object.fromEntries(searchParams))
  if (!query.success) {
    return NextResponse.json({ error: "Invalid parameters" }, { status: 400 })
  }

  // Step 3: Delegate — NO business logic here
  try {
    const result = await [domainService].[listMethod]({
      userId: session.user.id,
      ...query.data,
    })
    return NextResponse.json(result)
  } catch (error) {
    console.error("[GET /api/[resource]] failed:", { error })
    return NextResponse.json({ error: "Internal server error" }, { status: 500 })
  }
}

// ── POST Handler ───────────────────────────────────────────────────────────────
const CreateBodySchema = z.object({
  // name: z.string().min(1).max(255),
})

export async function POST(req: NextRequest): Promise<NextResponse> {
  // Step 1: Auth — ALWAYS FIRST
  const session = await auth()
  if (!session) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 })
  }

  // Step 2: Parse and validate request body
  const body = CreateBodySchema.safeParse(await req.json())
  if (!body.success) {
    return NextResponse.json({ error: "Invalid request body" }, { status: 400 })
  }

  // Step 3: Delegate — NO business logic here
  try {
    const result = await [domainService].[createMethod]({
      userId: session.user.id,
      ...body.data,
    })
    return NextResponse.json(result, { status: 201 })
  } catch (error) {
    console.error("[POST /api/[resource]] failed:", { error })
    return NextResponse.json({ error: "Internal server error" }, { status: 500 })
  }
}
// NOTE: If this file exceeds ~30 lines per handler, extract logic to features/
