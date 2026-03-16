---
name: rio-agent-spec-flow-analyzer
description: Codex port of `spec-flow-analyzer`. Analyze specs and plans from the user's perspective and surface missing flows, edge cases, and questions.
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Rio Agent Spec Flow Analyzer

Use this skill when the user provides a spec, requirements, or plan that needs flow validation.

## Analyze

- happy paths
- decision branches
- error states
- role / permission differences
- lifecycle transitions
- missing clarifications

## Output

- user flows
- edge cases
- ambiguous areas
- questions that must be resolved before implementation
