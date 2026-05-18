# tools/ — Shared Runtime Tools

Shared scripts, servers, and utilities available to all agents in the ai_software_factory framework.

## Directory Structure

```
tools/
├── factory-scripts/          # Factory management and validation scripts
│   ├── validate-framework.sh     # Validates all 11 agents have required files
│   ├── validate-skills.sh        # Validates all skills have 6 required files + sections
│   ├── credential-preflight.sh   # Tests API credentials (Supabase, OpenAI, Anthropic)
│   ├── memory-guard.sh           # Checks Claude process count and memory
│   └── agent-metrics.sh          # Agent invocation metrics dashboard
├── mcp-knowledge-search/     # MCP server for full-text knowledge search
│   ├── server.py                 # FastMCP server (5 tools)
│   ├── database.py               # SQLite FTS5 backend
│   ├── ingest.py                 # Document ingestion pipeline
│   ├── requirements.txt          # mcp>=1.0.0
│   ├── adapters/                 # Adapters: markdown, json_docs, dossier
│   └── README.md                 # Setup and configuration guide
└── document-generation/      # Document quality utilities
    ├── spellcheck_document.py    # Spell-check PPTX, DOCX, TXT, MD, PDF
    ├── validate_office_file.py   # Validate Office file structural integrity
    └── README.md                 # Usage and dependencies guide
```

## Quick Reference

### Factory Validation
```bash
# Validate entire factory structure
bash tools/factory-scripts/validate-framework.sh

# Validate all skills (verbose)
bash tools/factory-scripts/validate-skills.sh --verbose

# Check credentials before running integration tests
bash tools/factory-scripts/credential-preflight.sh ./my-project

# Check if safe to spawn more agents
bash tools/factory-scripts/memory-guard.sh

# Show agent activity metrics
bash tools/factory-scripts/agent-metrics.sh
```

### MCP Knowledge Search
```bash
# Install
pip install mcp>=1.0.0

# Configure in .mcp.json
# { "mcpServers": { "knowledge": { "command": "python", "args": ["tools/mcp-knowledge-search/server.py"] } } }

# Ingest documents
python tools/mcp-knowledge-search/ingest.py --config knowledge-config.json
```

### Document Checks
```bash
# Spell-check a PPTX
python tools/document-generation/spellcheck_document.py slides.pptx --lang pt-BR

# Validate a DOCX
python tools/document-generation/validate_office_file.py report.docx
```

## Access Policy

These tools are **build-time and runtime accessible** by all agents. They do not contain agent-specific knowledge.

- Agents may invoke scripts in `tools/factory-scripts/` for validation and monitoring
- The MCP server in `tools/mcp-knowledge-search/` provides runtime knowledge access
- Document generation tools in `tools/document-generation/` support output quality checks

Per the build/runtime isolation rule: tools here only expose functionality, not knowledge. Knowledge lives in each agent's `knowledge/` folder.
