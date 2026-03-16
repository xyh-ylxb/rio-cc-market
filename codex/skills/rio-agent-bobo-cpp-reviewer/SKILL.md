---
name: rio-agent-bobo-cpp-reviewer
description: Codex port of `bobo-cpp-reviewer`. Apply a strict C++ review lens focused on correctness, ownership, lifetime, concurrency, and maintainability.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
---

# Rio Agent bobo C++ Reviewer

Use this skill after touching C or C++ code, especially runtime, memory, ownership, or concurrency paths.

## Review Lens

- ownership and lifetime safety
- RAII discipline
- unnecessary complexity in existing files
- error handling and invariants
- API clarity
- test gaps around risky behavior
