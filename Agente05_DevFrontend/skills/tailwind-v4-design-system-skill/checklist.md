# Tailwind v4 Design System — Checklist

## Pre-Execution
- [ ] Files to review identified

## Violation Checks
- [ ] Inline `style={{}}` props — scanned and replaced
- [ ] Hardcoded hex colors — scanned and replaced with tokens
- [ ] Tailwind palette colors — scanned and replaced with tokens
- [ ] CSS module imports — flagged for removal

## Token Application
- [ ] Primary color: `bg-[var(--primary-color)]` or alias
- [ ] Text: `text-[var(--text-foreground)]` or `text-[var(--muted-foreground)]`
- [ ] Background: `bg-[var(--bg-background)]`
- [ ] Border: `border-[var(--border)]`
- [ ] Chart colors: `stroke="var(--primary-color)"` / `fill="var(--secondary-color)"`

## Compliance Output
- [ ] `design_token_compliant: true` confirmed
- [ ] All violations fixed or documented as exceptions

## Runtime Knowledge Policy
- [ ] Token map from `context_view.md` § 12 used
- [ ] No external design documentation consulted
