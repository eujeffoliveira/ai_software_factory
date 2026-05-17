# Bad Output: nextjs-react-component-skill

Missing companion files, using Client Component unnecessarily, no empty state:

```
Files produced:
- app/entities/page.tsx (Client Component, 120 lines — "use client" added, useEffect for data fetch)

component_type: ClientComponent (WRONG — should be ServerComponent)
has_loading_state: false (MISSING — blocks Gate 4)
has_error_state: false (MISSING — blocks Gate 4)
has_empty_state: false (MISSING — blank space when no data)
```

Issues: FM-01 (Client overuse), FM-02 (no loading), FM-03 (no error), FM-04 (no empty state).
