---
name: rio-core-plan
description: Codex port of `core:plan`. Turn a feature request, bug report, or improvement idea into a structured implementation plan grounded in the local repository.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Write
---

# Rio Core Plan

Use this skill when the user wants a plan before implementation.

## Inputs

- feature description
- bug report
- improvement idea
- optional constraints, owner, deadline, rollout notes

## Workflow

1. Read local instructions first: `AGENTS.md`, `README`, nearby docs, and the target area of the repo.
2. Research existing patterns in the repository before proposing new structure.
3. Pull in specialized Rio agent skills when the plan needs them:
   - `rio-agent-repo-research-analyst`
   - `rio-agent-best-practices-researcher`
   - `rio-agent-framework-docs-researcher`
   - `rio-agent-spec-flow-analyzer`
4. Produce a concrete markdown plan with:
   - problem statement
   - current state
   - implementation steps
   - file/module touch points
   - validation plan
   - risks and open questions
5. Prefer the smallest viable sequence over a grand design.

## Output Standard

Plans should be directly executable by Codex and should cite real paths when possible.

## Codex Notes

- Do not emit `/core:plan`.
- If the user wants the plan saved, write it to a repository file instead of replying only in chat.
