# Bad Output: frontend-error-state-skill

```tsx
// app/entities/error.tsx
// MISSING "use client" — Next.js will throw!
export default function Error({ error }: { error: Error }) {
  return (
    // WRONG: no role="alert"
    <div>
      {/* WRONG: exposes error.message to users — information disclosure */}
      <p>Error: {error.message}</p>
      {/* WRONG: no reset() button — user cannot recover */}
    </div>
  )
}
```

Issues: (1) Missing `"use client"` — Next.js throws build error. (2) `error.message` exposed — security/info disclosure violation. (3) No `reset()` button — user stuck. (4) No `role="alert"` — screen readers miss the error.
