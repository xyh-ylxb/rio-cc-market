---
name: rio-utils-create-agent-skill
description: Codex port of `utils:create-agent-skill`. Create or refine a Codex skill package using Rio's skill-authoring guidance.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
---

# Rio Utils Create Agent Skill

Use this skill when the user wants a new skill or wants an existing skill repaired.

## Workflow

1. Clarify the skill's trigger, scope, and deliverable.
2. Use `rio-create-agent-skills` for structure and writing guidance.
3. Create a skill package under the appropriate `skills/` directory.
4. Include only the resources the workflow actually needs.
5. Validate that the instructions are Codex-native, not Claude-plugin-specific.
