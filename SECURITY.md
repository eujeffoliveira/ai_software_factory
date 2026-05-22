# Security Policy

## Reporting issues

If you discover a potential security problem in this project, please do **not** open a public GitHub issue. Instead, report it privately:

1. Go to the GitHub repository page.
2. Click **Security** → **Report a vulnerability** (GitHub private advisory).
3. Describe what you found, steps to reproduce, and potential impact.

The maintainer will acknowledge reports within a reasonable time and coordinate a fix before any public disclosure.

---

## Secrets policy

**Never commit any of the following to this repository:**

- API keys or tokens (Anthropic, OpenAI, GitHub, Vercel, etc.)
- `.env` files containing real credentials
- Database passwords or connection strings with credentials
- Private keys or certificates
- Authentication tokens or session secrets
- Log files or database dumps containing personal or sensitive data

This applies to all file types: `.env`, `.ps1`, `.py`, `.json`, `.md`, `.log`, and any other format.

If you accidentally commit a secret, treat it as compromised immediately — rotate it and then remove it from git history.

---

## Credentials found in the repository

If you find credentials or secrets that appear to have been committed:

1. Open a private advisory (see Reporting above) rather than a public issue.
2. Do not exploit or share the found credential.
3. The maintainer will revoke/rotate the credential and clean the history.

---

## MCP logs

The MCP Knowledge Search server writes logs to `tools/mcp-knowledge-search/logs/`. These logs **must not** contain:

- API keys or tokens
- User data or personal information
- Database credentials
- Any other sensitive values

Check log output before committing. The `.gitignore` should cover `*.log` files; verify it does if you add new log paths.

---

## knowledge.db

The SQLite knowledge database (`knowledge.db`) indexes all `.md` files in the factory. Do not place files containing secrets or sensitive information in paths that are indexed (see `ingest.py` for the indexed paths). The `.gitignore` excludes `knowledge.db` from version control.

---

## Examples and templates

All example files (`examples/`, `templates/`, `bibliography/playbooks/`) must use placeholder values:

```
API_KEY=your-api-key-here
DATABASE_URL=postgresql://user:password@host/dbname
TOKEN=<your-token>
```

Never use real values, even for demonstration purposes.

---

## Third-party materials

Knowledge files may reference or summarize third-party books, papers, or articles. Ensure that:

- Referenced material is cited, not reproduced verbatim.
- You have the right to include any content you add.
- No proprietary or confidential material from employers or clients is included.

See `LICENSE-DOCS` for the full contributor content policy.
