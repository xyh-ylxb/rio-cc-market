---
name: rio-core-review
description: Codex port of `core:review`. Run a code review with findings-first output, branch awareness, and Rio review lenses.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
---

# Rio Core Review

Use this skill when the user asks for a review of a branch, diff, PR, or file set.

## Workflow

1. Determine review target and ensure the relevant code is present locally.
2. If isolation helps, use `rio-git-worktree`.
3. Inspect the diff and touched files before reading broad context.
4. Apply the relevant review lenses:
   - `rio-agent-architecture-strategist`
   - `rio-agent-pattern-recognition-specialist`
   - `rio-agent-code-simplicity-reviewer`
   - `rio-agent-performance-oracle`
   - `rio-agent-git-history-analyzer`
   - language-specific reviewer if applicable
5. Output findings first, ordered by severity.

## Output Format

- finding with file reference
- concrete risk or regression
- missing test or validation

Keep the summary brief and secondary.

## Codex Notes

- Do not ask the user to run a slash command.
- If no issues are found, say so explicitly and mention residual risk.
