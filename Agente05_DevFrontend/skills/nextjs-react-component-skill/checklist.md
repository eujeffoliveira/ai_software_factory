# React Component Implementation — Checklist

## Pre-Execution
- [ ] `server-component-selection-skill` output received
- [ ] API contract section verified for all data consumed

## Implementation
- [ ] Correct template used (Server or Client)
- [ ] For ClientComponent: `"use client"` is first line with justification comment
- [ ] TypeScript interfaces derived from API contract (no invented fields)
- [ ] No `any` types used

## Required States
- [ ] Loading state present if async route
- [ ] Error state present if page route
- [ ] Empty state present if list/table component

## Images and Styling
- [ ] `<Image>` from next/image used (zero `<img>` tags)
- [ ] Tailwind only — zero inline styles

## Runtime Knowledge Policy
- [ ] Patterns from `context_view.md` used
- [ ] No external documentation consulted at runtime
