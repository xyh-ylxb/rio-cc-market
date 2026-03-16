---
name: rio-hook-creator
description: Codex adaptation of `hook-creator`. Design automation around Codex using shell wrappers, git hooks, CI hooks, and repository scripts instead of Claude hook APIs.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
---

# Rio Hook Creator

Use this skill when the user wants workflow automation that would have been a Claude hook.

## Codex Mapping

Codex does not use Claude's hook configuration model. Replace hook use cases with one of:

- git hooks
- shell wrapper scripts
- CI jobs
- repo-local scripts invoked from `AGENTS.md`
- MCP server side automation if appropriate

## Workflow

1. Identify the event to intercept.
2. Choose the narrowest automation mechanism that actually exists in Codex or the surrounding toolchain.
3. Write the script or config.
4. Document invocation and safety constraints.
