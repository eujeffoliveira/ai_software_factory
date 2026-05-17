# Frontend State Management — Checklist

## Pre-Execution
- [ ] State requirement clearly described

## Decision Questions
- [ ] Does data change only on page load? → Server Component
- [ ] Does data change when user acts? → Server Action
- [ ] Does data change on a time interval? → SWR polling
- [ ] Is state purely transient UI (modal, tab)? → useState

## Output Verification
- [ ] Strategy is one of the four valid options
- [ ] Rationale explains why specifically
- [ ] If SWR: `polling_interval_ms` specified and ≥ 5000
- [ ] If Server Component: confirmed no client trigger applies

## Runtime Knowledge Policy
- [ ] Decision matrix from `knowledge/heuristics.md` H2 used
- [ ] No external state management documentation consulted
