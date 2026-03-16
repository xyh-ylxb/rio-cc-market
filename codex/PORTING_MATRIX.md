# Codex Porting Matrix

This branch ports the Claude-oriented Rio package into Codex-native skills and MCP installers.

## Commands

| Source | Codex target |
|---|---|
| `core:plan` | `rio-core-plan` |
| `core:work` | `rio-core-work` |
| `core:review` | `rio-core-review` |
| `core:compound` | `rio-core-compound` |
| `core:deepen-plan` | `rio-core-deepen-plan` |
| `core:plan-review` | `rio-core-plan-review` |
| `utils:pr-summary-cn` | `rio-utils-pr-summary-cn` |
| `utils:resolve-todos` | `rio-utils-resolve-todos` |
| `utils:create-agent-skill` | `rio-utils-create-agent-skill` |
| `utils:create-command` | `rio-utils-create-command` |
| `utils:heal-skill` | `rio-utils-heal-skill` |
| `utils:report-bug` | `rio-utils-report-bug` |

## Agents

| Source | Codex target |
|---|---|
| `general` | `rio-agent-general` |
| `spec-flow-analyzer` | `rio-agent-spec-flow-analyzer` |
| `best-practices-researcher` | `rio-agent-best-practices-researcher` |
| `framework-docs-researcher` | `rio-agent-framework-docs-researcher` |
| `git-history-analyzer` | `rio-agent-git-history-analyzer` |
| `repo-research-analyst` | `rio-agent-repo-research-analyst` |
| `architecture-strategist` | `rio-agent-architecture-strategist` |
| `bobo-cpp-reviewer` | `rio-agent-bobo-cpp-reviewer` |
| `bobo-python-reviewer` | `rio-agent-bobo-python-reviewer` |
| `code-simplicity-reviewer` | `rio-agent-code-simplicity-reviewer` |
| `pattern-recognition-specialist` | `rio-agent-pattern-recognition-specialist` |
| `performance-oracle` | `rio-agent-performance-oracle` |

## Skills

| Source | Codex target |
|---|---|
| `compound-docs` | `rio-compound-docs` |
| `creating-agent-skills` | `rio-create-agent-skills` |
| `git-worktree` | `rio-git-worktree` |
| `hook-creator` | `rio-hook-creator` |
| `skill-creator` | `rio-skill-creator` |

## MCP

| Source | Codex target |
|---|---|
| `plugins/rio-plugin/.mcp.json` | `codex/mcp/rio-mcp-servers.json` |
| manual plugin loading | `install-codex-mcp.sh` using `codex mcp add` |
