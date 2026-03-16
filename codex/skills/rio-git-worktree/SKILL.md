---
name: rio-git-worktree
description: Manage Git worktrees for Codex workflows without relying on Claude plugin runtime paths.
allowed-tools:
  - Bash
  - Read
---

# Rio Git Worktree

Use this skill when branch isolation would make implementation or review safer.

## Script Location

After installation, the helper script lives at:

```bash
~/.codex/skills/rio-git-worktree/scripts/worktree-manager.sh
```

Run that script instead of manually composing `git worktree` commands when you want Rio's opinionated setup.

## Supported Commands

```bash
~/.codex/skills/rio-git-worktree/scripts/worktree-manager.sh create <branch-name> [base-branch]
~/.codex/skills/rio-git-worktree/scripts/worktree-manager.sh list
~/.codex/skills/rio-git-worktree/scripts/worktree-manager.sh switch <worktree-name>
~/.codex/skills/rio-git-worktree/scripts/worktree-manager.sh copy-env [worktree-name]
~/.codex/skills/rio-git-worktree/scripts/worktree-manager.sh cleanup
```

## Behavior

- Worktrees are created under `.worktrees/`
- `.env*` files are copied into the new worktree, except `.env.example`
- `.worktrees` is added to `.gitignore` if needed
- Base branch defaults to the repository default branch when detectable

## When to Use It

- reviewing a branch in isolation
- parallel feature development
- keeping a dirty main workspace untouched
- switching quickly between tasks
