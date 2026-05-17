# Frontend Error State — Checklist

## Pre-Execution
- [ ] Route path confirmed
- [ ] Recovery strategy selected

## Implementation
- [ ] `"use client"` on first line (Next.js requirement)
- [ ] Props typed: `{ error: Error & { digest?: string }, reset: () => void }`
- [ ] `error.message` NOT displayed to users
- [ ] Internal logging: `console.error` with digest only
- [ ] Generic user-friendly message used

## UI Requirements
- [ ] `role="alert"` on the error container
- [ ] `aria-live="assertive"` on the container
- [ ] "Try again" button calls `reset()`
- [ ] Button has accessible label

## Runtime Knowledge Policy
- [ ] Error state pattern from `context_view.md` § 5 used
- [ ] `Error_State_Template.tsx` used as starting point
