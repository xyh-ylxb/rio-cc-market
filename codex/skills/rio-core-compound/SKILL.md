---
name: rio-core-compound
description: Codex port of `core:compound`. Capture a solved problem as reusable engineering knowledge.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
---

# Rio Core Compound

Use this skill when a problem has been solved and should be documented for reuse.

## Workflow

1. Confirm the issue is actually resolved.
2. Gather the concrete evidence:
   - symptom
   - root cause
   - fix
   - verification commands
3. Use `rio-compound-docs` to place the write-up in a searchable format.
4. Link to the exact files or commands involved.

## Quality Bar

- no speculative root causes
- no missing verification
- no vague “fixed by adjusting config” summaries
