# accessibility-regression-skill — Good Output Example

## 2 primary flows tested: Login, Create Task

```json
{
  "flows_tested": 2,
  "flows_passed": 2,
  "flows_failed": 0,
  "violations": []
}
```

Evidence:
- Login: Tab navigates to email → password → submit. Focus visible. `aria-label` on submit button. Error announced via `role="alert"`.
- Create Task: Tab through all form fields. Labels present (`getByLabel` works). Error announced. Keyboard submission works.
