---
name: rio-agent-code-simplicity-reviewer
description: Codex port of `code-simplicity-reviewer`. Find unnecessary complexity and push the implementation toward the simplest form that still satisfies the requirement.
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Rio Agent Code Simplicity Reviewer

Use this skill after implementation or during review.

## Check

- extra abstraction
- nested logic that can be flattened
- repeated checks
- speculative generalization
- code that should be deleted instead of wrapped
