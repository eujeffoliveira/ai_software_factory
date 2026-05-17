# playwright-e2e-skill — Good Output Example

## Generated Test (Compliant)

```typescript
test("creates task successfully — AC-001", async ({ page }) => {
  await page.goto("/tasks/new")
  await page.getByLabel("Task Title").fill("Q4 Planning")
  await page.getByRole("button", { name: "Create Task" }).click()
  await expect(page.getByRole("alert")).toContainText("Task created")
})

test("keyboard navigation works — AC-006", async ({ page }) => {
  await page.goto("/tasks/new")
  await page.keyboard.press("Tab")
  await expect(page.locator(":focus")).toBeVisible()
  const focused = page.locator(":focus")
  await expect(focused).toHaveAttribute("aria-label")
})
```

## Output
```json
{
  "test_file_path": "e2e/tasks/create-task.spec.ts",
  "tests_generated": 3,
  "selector_violations_found": 0,
  "accessibility_tests_included": true
}
```
