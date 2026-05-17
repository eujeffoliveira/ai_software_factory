# Bad Output Example — structured-logging-skill

```typescript
// BAD: string concatenation — not parseable by log aggregators
catch (error: any) {
  console.log("Error creating task: " + error.message + " for user " + userId)
  // ^ Cannot be parsed by Datadog/CloudWatch structured log queries
  // ^ Reveals error.message to wherever logs go (may be accessible)
  
  return NextResponse.json({ error: error.message })  // ALSO WRONG: exposes to client
}

// BAD: no context — impossible to debug
catch (error) {
  console.error("something went wrong")  // who? what? which record?
}

// BAD: sensitive data in log
catch (error) {
  console.error("Auth failed:", { error, password: input.password, token: session.token })
  // ^ Passwords and tokens in logs = security violation
}
```

| Violation | Impact | Fix |
|-----------|--------|-----|
| String concatenation | Not parseable | `console.error("[loc]:", { error, userId })` |
| No context | Not debuggable | Include userId, entityId, operation context |
| Sensitive data in log | Security violation | Never log passwords, tokens, keys |
