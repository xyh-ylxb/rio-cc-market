---
name: rio-core-plan-review
description: Codex port of `core:plan-review`. Review a plan from multiple engineering angles and identify missing detail before implementation starts.
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Rio Core Plan Review

Use this skill when the user wants feedback on a plan or spec before coding.

## Workflow

1. Read the plan completely.
2. Detect the dominant language, runtime, and subsystem.
3. Apply matching Rio review skills:
   - `rio-agent-bobo-cpp-reviewer` for C/C++
   - `rio-agent-bobo-python-reviewer` for Python
   - `rio-agent-code-simplicity-reviewer`
   - `rio-agent-architecture-strategist`
   - `rio-agent-spec-flow-analyzer` for user-facing or workflow-heavy changes
4. Return findings grouped by:
   - correctness gaps
   - missing validation
   - sequencing problems
   - scope risk

## Output

Prefer actionable findings over general praise.
