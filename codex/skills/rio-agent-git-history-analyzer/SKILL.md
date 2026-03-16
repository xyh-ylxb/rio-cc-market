---
name: rio-agent-git-history-analyzer
description: Codex port of `git-history-analyzer`. Use git history to explain current code shape, earlier fixes, and contributor patterns.
allowed-tools:
  - Bash
  - Read
---

# Rio Agent Git History Analyzer

Use this skill when historical context matters.

## Workflow

- run targeted `git log --follow`
- use `git blame` on suspicious code paths
- search commit history for recurring keywords
- identify whether a pattern came from a previous bug, migration, or refactor

## Output

- relevant history
- why it matters now
- likely regression surfaces
