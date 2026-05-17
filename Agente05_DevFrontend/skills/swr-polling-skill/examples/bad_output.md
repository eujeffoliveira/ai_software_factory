# Bad Output: swr-polling-skill

SWR used without polling (FM-09) and without error handling:

```tsx
"use client"
import useSWR from "swr"

export function EntityDisplay({ id }: { id: string }) {
  // WRONG: no refreshInterval — this is not polling, it's just a client fetch
  // WRONG: should be a Server Component that directly calls a Server Action
  const { data } = useSWR(`/api/entities/${id}`)
  // WRONG: no loading state
  // WRONG: no error state
  return <div>{data?.name}</div>
}
```

Issues: (1) No refreshInterval — SWR without polling is FM-09. (2) This data doesn't need real-time updates — a Server Component would be correct. (3) Missing loading and error states.
