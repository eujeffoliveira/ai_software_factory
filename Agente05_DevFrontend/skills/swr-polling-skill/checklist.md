# SWR Polling — Checklist

## Pre-Execution
- [ ] Endpoint verified in API_Contract.json
- [ ] Polling interval ≥ 5000ms
- [ ] `frontend-state-management-skill` confirmed swr_polling strategy

## Implementation
- [ ] `"use client"` with DR003/DR004 justification (SWR uses browser APIs)
- [ ] `useSWR<ResponseType>` typed with contract response type
- [ ] `refreshInterval` explicitly set
- [ ] `revalidateOnFocus: false` (recommended)
- [ ] Fetcher function handles non-ok responses

## Required States
- [ ] Loading state present (skeleton or pulse)
- [ ] Error state present (inline, non-blocking)

## Runtime Knowledge Policy
- [ ] SWR pattern from `context_view.md` § 8 used
- [ ] No external SWR documentation consulted
