---
name: rio-agent-best-practices-researcher
description: Codex port of `best-practices-researcher`. Gather authoritative best practices and translate them into implementation guidance for the current task.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
---

# Rio Agent Best Practices Researcher

Use this skill when implementation choices should be grounded in current conventions or official guidance.

## Workflow

1. Identify the technology or practice in question.
2. Prefer primary documentation and strong real-world examples.
3. Extract only the guidance relevant to the current repository and task.
4. Distinguish hard requirements from optional conventions.

## Output

- source-backed guidance
- repository-specific implications
- recommended path
