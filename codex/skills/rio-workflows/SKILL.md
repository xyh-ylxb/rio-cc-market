---
name: rio-workflows
description: Codex-native version of the rio workflow pack. Use when the user wants structured planning, execution, review, PR summary, or compound documentation without Claude slash commands.
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - Grep
  - Glob
---

# Rio Workflows

Use this skill when the user asks for any of the following Claude-style workflows in Codex:

- `core:plan`
- `core:work`
- `core:review`
- `core:deepen-plan`
- `core:plan-review`
- `core:compound`
- `utils:pr-summary-cn`

This skill replaces slash-command entrypoints with Codex-native behavior.

## Workflow Mapping

### 1. Plan Work

When the user wants a feature plan or bug-fix plan:

- Inspect the repository first.
- Read local `AGENTS.md`, `README`, and nearby docs before proposing structure.
- Gather concrete references from the codebase.
- Produce a markdown plan with:
  - objective
  - current state
  - constraints
  - implementation steps
  - validation steps
  - risks / open questions

Prefer file-backed plans when the user is asking to execute later.

### 2. Execute a Plan

When the user gives a plan/spec/todo file:

- Read the whole input before editing code.
- Clarify only if ambiguity is material.
- Break work into concrete tasks and keep progress visible.
- Implement incrementally.
- Run the smallest relevant verification after each meaningful change.
- Finish with a concise outcome plus remaining risks.

If branch isolation would help, use the `rio-git-worktree` skill.

### 3. Review Code

When the user asks for review:

- Default to a code-review mindset.
- Findings come first.
- Order findings by severity.
- Include exact file references and explain the behavior or regression risk.
- Keep summaries brief and secondary.

Review checklist:

- correctness
- regressions
- missing tests
- operational risk
- maintainability

### 4. Deepen a Plan

When the user wants more detail:

- Expand the existing plan rather than rewriting from scratch.
- Add architecture edges, dependencies, rollout steps, and explicit test strategy.
- Surface assumptions that would block implementation.
- Keep the structure easy to execute.

### 5. Plan Review

When the user wants feedback on a plan:

- Challenge hidden complexity.
- Look for missing validation, rollback, and ownership details.
- Call out unrealistic sequencing.
- Suggest the smallest viable version where scope is bloated.

### 6. Compound Documentation

When the user wants to preserve a solution or pattern:

- Summarize the problem, root cause, fix, and verification.
- Store the write-up in the repository's existing documentation style.
- Prefer references to real files and commands over generic prose.

### 7. PR Summary in Chinese

When the user wants a Chinese PR summary:

- Diff against the requested base branch, defaulting to `master` if that is the repository convention.
- Summarize:
  - what changed
  - why it changed
  - test evidence
  - risks / follow-ups
- Use concise Chinese fit for a PR body or release note.

## Operating Rules

- Do not emit Claude slash commands as the answer.
- Convert the intent into normal Codex actions.
- Prefer repo-local conventions over generic templates.
- Be explicit when a Claude-only capability has no Codex equivalent.
