---
name: rio-utils-heal-skill
description: Codex port of `utils:heal-skill`. Repair a broken or outdated skill package after its instructions fail in practice.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Edit
  - Write
  - Bash
---

# Rio Utils Heal Skill

Use this skill when a skill's instructions are wrong, stale, or coupled to the wrong runtime.

## Workflow

1. Identify the failing skill and the exact bad instruction.
2. Trace the mismatch to one of:
   - stale APIs
   - wrong paths
   - Claude-only assumptions
   - missing preconditions
3. Patch the skill and related assets.
4. Re-run the relevant check or command if possible.
5. Summarize what was corrected and what remains risky.
