# Good Output: swr-polling-skill

A job status indicator polling every 30 seconds with loading and error states:

```tsx
"use client"
// JUSTIFICATION: uses useSWR for real-time polling (DR003 — SWR requires browser fetch API)
import useSWR from "swr"
import type { JobStatus } from "@/features/jobs/types"

const fetcher = (url: string) =>
  fetch(url).then((r) => { if (!r.ok) throw new Error("Failed"); return r.json() as Promise<JobStatus> })

export function SyncJobStatusIndicator({ jobId }: { jobId: string }) {
  const { data, error, isLoading } = useSWR<JobStatus>(
    `/api/jobs/${jobId}/status`,
    fetcher,
    { refreshInterval: 30_000, revalidateOnFocus: false }
  )
  if (isLoading) return <div className="animate-pulse h-4 w-20 bg-muted rounded" aria-label="Loading status" />
  if (error) return <span className="text-sm text-destructive" role="alert">Status unavailable</span>
  return <span aria-live="polite">{data?.status}</span>
}
```

Output:
```json
{ "file_path": "features/jobs/components/SyncJobStatusIndicator.tsx", "has_loading_state": true, "has_error_state": true, "refresh_interval_ms": 30000, "endpoint_verified": true }
```
