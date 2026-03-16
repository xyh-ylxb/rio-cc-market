# Rio Codex Port Guide

This branch packages `rio-plugin` concepts for Codex instead of Claude Code marketplace installs.

## Layout

- `install-codex.sh`: Install Codex-native assets into `~/.codex/`
- `codex/skills/`: Skills that Codex can load directly
- `codex/mcp/`: MCP config examples copied from the Claude plugin package
- `plugins/rio-plugin/`: Original Claude-oriented source material kept as reference

## Porting Rules

- Do not add new dependencies on Claude marketplace metadata such as `.claude-plugin/marketplace.json`.
- Prefer Codex `SKILL.md` skills and repository `AGENTS.md` instructions over slash-command docs.
- Keep Codex install assets self-contained: installed skills must not rely on `${CLAUDE_PLUGIN_ROOT}` or `~/.claude/...`.
- When a Claude command is useful in Codex, convert it into a workflow skill instead of documenting `/command` syntax.

## Expected Installation Flow

Users should be able to run:

```bash
git clone -b codex <repo-url>
cd rio-cc-market
./install-codex.sh
```

The script installs the Codex-compatible skills and copies MCP examples for manual merge into Codex config.
