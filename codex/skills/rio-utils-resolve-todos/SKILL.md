---
name: rio-utils-resolve-todos
description: Codex port of `utils:resolve-todos`. Find TODOs in a repository, triage them, and resolve them in a dependency-aware sequence.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Edit
  - Write
---

# Rio Utils Resolve Todos

Use this skill when the user wants TODO comments resolved across a file, directory, or repository.

## Workflow

1. Scan the target path for TODO/FIXME/HACK markers.
2. Group findings by file and dependency order.
3. Resolve independent TODOs first.
4. For each TODO:
   - understand surrounding code
   - implement the minimum real fix
   - verify the affected behavior
5. Report unresolved TODOs with reason if blocked.

## Codex Notes

- Replace Claude parallel subagents with careful batching or sequential execution when needed.
- Do not delete TODOs without implementing the intended behavior.
