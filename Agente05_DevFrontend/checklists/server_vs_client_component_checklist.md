# Server vs. Client Component Checklist

**Agent:** Agente05_DevFrontend
**Skill:** server-component-selection-skill
**Run:** Before implementing EVERY new component

## Runtime Knowledge Policy

> Consult `Agente05_DevFrontend/knowledge/decision_rules.md` (DR001–DR006) and `Agente05_DevFrontend/knowledge/heuristics.md` (H1) for the decision logic. Do not consult external React documentation at runtime.

---

## Decision Process: Run in Order

### Step 1 — Check Client Component Triggers (DR001–DR005)

Answer each question about the component you are about to implement:

- [ ] **DR001** Does this component use `useState` or `useReducer`?
- [ ] **DR002** Does this component use `useEffect`, `useLayoutEffect`, `useRef`, or `useCallback`?
- [ ] **DR003** Does this component attach DOM event handlers (`onClick`, `onChange`, `onSubmit`, `onKeyDown`, etc.)?
- [ ] **DR004** Does this component access browser APIs (`window`, `document`, `localStorage`, `navigator`, `IntersectionObserver`, etc.)?
- [ ] **DR005** Does this component import from `recharts` or another browser-only library?

**If any of the above is YES:** → Proceed to Step 2 (Client Component)
**If ALL are NO:** → Skip to Step 3 (Server Component)

---

### Step 2 — Client Component Confirmation

If a Client Component is required:

- [ ] **CC-01** Identified which specific trigger(s) apply (check all that apply above)
- [ ] **CC-02** Confirmed the trigger is actually used (not just "might be used")
- [ ] **CC-03** Evaluated whether the state/effect can be lifted to a Server Component parent instead
- [ ] **CC-04** Determined the minimum subtree that needs `"use client"` (push boundary as deep as possible)
- [ ] **CC-05** Prepared the justification comment for the first line of the file
- [ ] **CC-06** Selected the `Client_Component_Template.tsx` as the starting point

**Write the comment:** `// JUSTIFICATION: uses [hook/handler/API] for [specific purpose]`

---

### Step 3 — Server Component Confirmation

If a Server Component is appropriate:

- [ ] **SC-01** Confirmed the component has NONE of the DR001–DR005 triggers
- [ ] **SC-02** Verified the component only reads/renders data (no mutations initiated here)
- [ ] **SC-03** If the component fetches async data, declared it `async function`
- [ ] **SC-04** Confirmed NO `"use client"` directive will be added
- [ ] **SC-05** Identified the Server Action to call for data (or confirmed it receives data via props)
- [ ] **SC-06** Selected the `Server_Component_Template.tsx` as the starting point
- [ ] **SC-07** Identified required companion files: `loading.tsx` and `error.tsx`

---

### Step 4 — Component Boundary Review

For Client Components, always minimize the client boundary:

- [ ] **BOUND-01** The `"use client"` component does only what requires the client (the interactive part)
- [ ] **BOUND-02** Static/data-reading parts of the UI are in a separate Server Component
- [ ] **BOUND-03** Server Components are passed as `children` or props to the Client Component when possible
- [ ] **BOUND-04** No unnecessary imports pulled into the Client boundary (each import ships to browser)

**Example of minimized boundary:**
```tsx
// Good: thin Client wrapper around Server children
"use client"
export function AccordionWrapper({ children }: { children: React.ReactNode }) {
  const [open, setOpen] = useState(false)
  return <div onClick={() => setOpen(!open)}>{children}</div>
}

// The accordion content is a Server Component (reads data):
// <AccordionWrapper><ServerDataContent /></AccordionWrapper>
```

---

## Decision Output Summary

After running this checklist, document your decision:

```
Component: [ComponentName]
Type: SERVER_COMPONENT | CLIENT_COMPONENT
Trigger: N/A (Server) | DR001 (useState) | DR002 (useEffect) | DR003 (handlers) | DR004 (browser API) | DR005 (Recharts)
Justification: [1–2 sentence explanation]
Template: Server_Component_Template.tsx | Client_Component_Template.tsx
Companion files needed: loading.tsx: YES/NO | error.tsx: YES/NO | EmptyState: YES/NO
```

---

**Sign-off:** Decision documented → proceed to `nextjs-react-component-skill`
