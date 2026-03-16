---
name: rio-skill-creator
description: Codex port of `skill-creator`. Guide the design, packaging, and maintenance of reusable Codex skills.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
---

# Rio Skill Creator

Use this skill when the user wants to design a new skill package or improve an existing one.

## Focus

- what problem repeats often enough to deserve a skill
- what instructions should live in the skill vs `AGENTS.md`
- what scripts, templates, or references should be bundled
- how to keep the package small and testable

## Packaging Advice

- one clear skill purpose
- stable directory name
- executable scripts only when they remove real repetition
- document assumptions and prerequisites explicitly
