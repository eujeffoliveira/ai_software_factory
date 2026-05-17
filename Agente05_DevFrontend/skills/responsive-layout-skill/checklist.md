# Responsive Layout — Checklist

## Pre-Execution
- [ ] Layout spec defined (columns, breakpoints, container)

## Mobile-First Verification
- [ ] Default CSS (no prefix) produces a usable mobile layout
- [ ] No layout that only specifies `lg:` classes
- [ ] Single column on mobile for all grid layouts (`grid-cols-1` default)

## Breakpoints
- [ ] `sm:` used for first layout enhancement (if needed)
- [ ] `lg:` used for primary desktop layout switch
- [ ] Logical ascending order applied

## Container
- [ ] Max-width applied (`max-w-7xl` or project standard)
- [ ] Horizontal padding: `px-4 sm:px-6 lg:px-8`

## Overflow
- [ ] Tables have `overflow-x-auto` wrapper
- [ ] No unintended horizontal overflow on mobile

## Runtime Knowledge Policy
- [ ] Responsive patterns from `context_view.md` § 14 used
- [ ] Card 012 from `knowledge/knowledge_cards.md` referenced
