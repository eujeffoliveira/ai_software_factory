# Good Output Example — structured-logging-skill

```typescript
// Good: structured object context
catch (error) {
  console.error("createTask failed:", {
    error,
    userId: session.user.id,
    title: input.title,
  })
  throw new Error("Failed to create task. Please try again.")
}

// Good: Route Handler error logging
catch (error) {
  console.error("[GET /api/tasks] failed:", { error })
  return NextResponse.json({ error: "Internal server error" }, { status: 500 })
}

// Good: Cron job failure logging
catch (error) {
  console.error("[cron/daily-sync] job failed:", {
    error,
    processedSoFar: processed,
  })
  status = "error"
}
```

**Why correct:** Location prefix, structured object with error + context, no string concatenation, no sensitive data, no `error.message` to client.
