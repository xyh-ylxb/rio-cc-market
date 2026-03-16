---
name: rio-core-deepen-plan
description: Codex port of `core:deepen-plan`. Expand an existing plan with implementation detail, dependencies, validation, and rollout structure.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
  - Edit
  - Write
---

# Rio Core Deepen Plan

Use this skill when a plan exists but lacks enough detail to execute safely.

## Workflow

1. Read the current plan fully.
2. Inventory repository-local skills, docs, and patterns that can sharpen the plan.
3. Expand each weak section with:
   - concrete code touch points
   - dependencies and ordering
   - tests and verification
   - rollback or mitigation notes
4. Pull in relevant Rio agent skills for deeper analysis by section.
5. Preserve the original intent while making execution less ambiguous.

## Focus Areas

- missing acceptance criteria
- unrealistic sequencing
- absent test strategy
- hidden rollout risk
- vague ownership or scope
