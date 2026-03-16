---
name: rio-utils-report-bug
description: Codex port of `utils:report-bug`. Prepare a high-quality bug or feature request for the Rio plugin or its Codex port.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
---

# Rio Utils Report Bug

Use this skill when the user wants to report a bug or request a feature in the Rio toolchain.

## Workflow

1. Collect:
   - expected behavior
   - actual behavior
   - reproduction steps
   - environment details
   - logs or screenshots if relevant
2. Identify whether the issue belongs to:
   - Claude marketplace version
   - Codex port
   - shared Rio content
3. Produce a ready-to-file issue body in markdown.
4. If the user wants, prepare `gh issue create` inputs, but do not invent evidence.

## Output Sections

- summary
- environment
- repro
- expected vs actual
- evidence
- suspected scope
