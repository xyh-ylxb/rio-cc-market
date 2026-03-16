---
name: rio-core-work
description: Codex port of `core:work`. Execute a plan or spec incrementally, keeping progress visible and verification tight.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Edit
  - Write
---

# Rio Core Work

Use this skill when the user gives a plan, spec, or todo file and wants implementation.

## Workflow

1. Read the whole input before touching code.
2. Clarify only if ambiguity is material to correctness.
3. Break the work into concrete tasks and keep that task list updated during execution.
4. Follow existing repository patterns before introducing new abstractions.
5. Implement incrementally and run the smallest relevant validation after each meaningful change.
6. If branch isolation would help, use `rio-git-worktree`.
7. Finish with:
   - what changed
   - verification run
   - remaining risks

## Quality Bar

- no speculative code
- no silent scope expansion
- no skipped validation unless explicitly blocked

## Codex Notes

- Replace Claude `TodoWrite` guidance with explicit progress tracking in the conversation or task plan.
- Replace slash-command references with normal Codex actions.
