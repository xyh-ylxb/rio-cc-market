---
name: rio-utils-create-command
description: Codex port of `utils:create-command`. Create a Codex-native workflow entrypoint, typically as a skill or AGENTS.md pattern, instead of a Claude slash command.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
---

# Rio Utils Create Command

Use this skill when the user wants a reusable workflow entrypoint.

## Codex Mapping

Claude slash commands do not exist here. In Codex, the equivalent is usually one of:

- a skill in `~/.codex/skills/`
- a repo-local workflow described in `AGENTS.md`
- a helper shell script or automation entrypoint

## Workflow

1. Clarify the desired trigger and outcome.
2. Decide whether the right target is a skill, AGENTS.md section, or script.
3. Author the chosen entrypoint in the repo's style.
4. Document how the user invokes it in Codex.
