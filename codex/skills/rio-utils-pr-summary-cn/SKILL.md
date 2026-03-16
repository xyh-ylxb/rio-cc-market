---
name: rio-utils-pr-summary-cn
description: Codex port of `utils:pr-summary-cn`. Generate a concise Chinese PR summary from the real diff against a base branch.
allowed-tools:
  - Bash
  - Read
---

# Rio Utils PR Summary CN

Use this skill when the user wants a Chinese PR summary or release-note style recap.

## Workflow

1. Determine the base branch, defaulting to `master` if the repo uses that convention.
2. Inspect:
   - current branch
   - commit list vs base
   - changed files
3. Summarize in Chinese:
   - 改了什么
   - 为什么改
   - 如何验证
   - 风险和后续项

## Rules

- derive content from real git state
- do not invent test evidence
- keep it suitable for PR body paste
