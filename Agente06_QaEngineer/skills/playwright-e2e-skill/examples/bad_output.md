# playwright-e2e-skill — Bad Output Example

## Problematic Test (CSS Selectors)

```typescript
// BAD: Uses CSS selectors — couples test to markup implementation
test("creates task", async ({ page }) => {
  await page.goto("/tasks/new")
  await page.locator(".task-title-input").fill("Q4 Planning")  // BAD: CSS class
  await page.locator("#submit-btn").click()                     // BAD: ID selector
  await expect(page.locator(".success-toast")).toBeVisible()   // BAD: CSS class
  await page.waitForTimeout(2000)                               // BAD: hardcoded wait
})
```

## Violations Found
1. `.task-title-input` — CSS class selector → RETURNED_FOR_REVISION (DR002)
2. `#submit-btn` — ID selector → RETURNED_FOR_REVISION (DR002)
3. `.success-toast` — CSS class selector → RETURNED_FOR_REVISION (DR002)
4. `waitForTimeout(2000)` — hardcoded wait causes flaky tests (FM-06)
5. No accessibility test included
6. No error state test included

## Correct Versions
- `.task-title-input` → `page.getByLabel("Task Title")`
- `#submit-btn` → `page.getByRole("button", { name: "Create Task" })`
- `.success-toast` → `page.getByRole("alert")`
- `waitForTimeout(2000)` → `await expect(page.getByRole("alert")).toBeVisible()`
