---
name: rio-create-agent-skills
description: Codex port of `create-agent-skills`. Create or refine skill packages for Codex with clear triggers, minimal assets, and maintainable instructions.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
---

# Rio Create Agent Skills

Use this skill when authoring or repairing a skill.

## Principles

- the trigger should be explicit
- instructions should be procedural, not essay-style
- bundle only the assets the workflow actually needs
- avoid Claude-only assumptions like slash commands or plugin roots

## Standard Skill Shape

- YAML frontmatter
- short purpose statement
- concrete workflow
- validation guidance
- bundled scripts or references only when necessary

## Target Locations

- user-global skills: `~/.codex/skills/<skill-name>/`
- repo-local coordination: `AGENTS.md`
