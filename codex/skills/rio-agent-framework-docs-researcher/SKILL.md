---
name: rio-agent-framework-docs-researcher
description: Codex port of `framework-docs-researcher`. Research framework and library documentation with attention to the version actually used by the project.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
---

# Rio Agent Framework Docs Researcher

Use this skill when a task depends on understanding a library or framework correctly.

## Workflow

1. Detect the dependency and version from the repository when possible.
2. Gather the relevant official docs or source references.
3. Focus on APIs, constraints, examples, and migration gotchas that affect the task.
4. Map those findings back to touched files and code patterns in the repo.
